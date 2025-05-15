#include "ProxyModule.h"
#include "BotLogger.h"

#include <memory>

ProxyModule::ProxyModule()
    : m_io_context(std::make_shared<boost::asio::io_context>()),
      m_acceptor(*m_io_context), m_resolver(*m_io_context), m_local_port(1337) {}

ProxyModule::~ProxyModule() {
  try {
    m_io_context->stop();
    if (m_worker_thread.joinable()) {
      m_worker_thread.join();
    }
  } catch (const std::exception &e) {
    BotLogger::getInstance().save_exception(e, LogLevel::ERROR, BotModules::PROXY);
  }
}

std::string ProxyModule::get_module_name() const {
  return "Proxy";
}

void ProxyModule::initialize_proxy(int local_port, const std::string &target_host, int target_port) {
  try {
    m_local_port = local_port;
    m_target_host = target_host;
    m_target_port = target_port;

    boost::asio::ip::tcp::endpoint endpoint(boost::asio::ip::tcp::v4(), m_local_port);
    m_acceptor.open(endpoint.protocol());
    m_acceptor.set_option(boost::asio::ip::tcp::acceptor::reuse_address(true));
    m_acceptor.bind(endpoint);
    m_acceptor.listen();

    BotLogger::getInstance().save_log("Proxy initialized successfully.", LogLevel::INFO, BotModules::PROXY);
    accept_connection();

    m_worker_thread = std::thread([this]() {
      try {
        m_io_context->run();
      } catch (const std::exception &e) {
        BotLogger::getInstance().save_exception(e, LogLevel::ERROR, BotModules::PROXY);
      }
    });
  } catch (const std::exception &e) {
    BotLogger::getInstance().save_exception(e, LogLevel::ERROR, BotModules::PROXY);
  }
}

void ProxyModule::accept_connection() {
  auto client_socket = std::make_shared<boost::asio::ip::tcp::socket>(*m_io_context);
  m_acceptor.async_accept(*client_socket, [this, client_socket](boost::system::error_code ec) {
    if (!ec) {
      BotLogger::getInstance().save_log("Connection accepted successfully.", LogLevel::INFO, BotModules::PROXY);
      handle_client(client_socket);
    } else {
      BotLogger::getInstance().save_log("Failed to accept connection: " + ec.message(), LogLevel::ERROR, BotModules::PROXY);
    }
    accept_connection(); // Continue accepting next client
  });
}

void ProxyModule::handle_client(std::shared_ptr<boost::asio::ip::tcp::socket> client_socket) {
  auto server_socket = std::make_shared<boost::asio::ip::tcp::socket>(*m_io_context);
  m_resolver.async_resolve(m_target_host, std::to_string(m_target_port),
    [this, client_socket, server_socket](const boost::system::error_code &ec, boost::asio::ip::tcp::resolver::results_type endpoints) {
      if (!ec) {
        boost::asio::async_connect(*server_socket, endpoints,
          [this, client_socket, server_socket](const boost::system::error_code &ec, const boost::asio::ip::tcp::endpoint &) {
            if (!ec) {
              start_forwarding(client_socket, server_socket);
              start_forwarding(server_socket, client_socket);
            } else {
              BotLogger::getInstance().save_log("Failed to connect to target server: " + ec.message(), LogLevel::ERROR, BotModules::PROXY);
            }
          });
      } else {
        BotLogger::getInstance().save_log("Failed to resolve target server: " + ec.message(), LogLevel::ERROR, BotModules::PROXY);
      }
    });
}

void ProxyModule::start_forwarding(std::shared_ptr<boost::asio::ip::tcp::socket> source,
                                   std::shared_ptr<boost::asio::ip::tcp::socket> destination) {
  auto buffer = std::make_shared<std::vector<char>>(1024);
  source->async_read_some(boost::asio::buffer(*buffer),
    [this, source, destination, buffer](boost::system::error_code ec, std::size_t length) {
      if (!ec) {
        boost::asio::async_write(*destination, boost::asio::buffer(*buffer, length),
          [this, source, destination, buffer](boost::system::error_code ec, std::size_t) {
            if (!ec) {
              start_forwarding(source, destination);
            }
          });
      }
    });
}

void ProxyModule::execute_module(const nlohmann::json &instructions) {
  int local_port = instructions["local_port"];
  std::string target_host = instructions["target_host"];
  int target_port = instructions["target_port"];
  initialize_proxy(local_port, target_host, target_port);
}
