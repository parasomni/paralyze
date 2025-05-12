#include "ProxyModule.h"
#include "BotLogger.h"

ProxyModule::ProxyModule()
    : m_acceptor(m_io_context), m_client_socket(m_io_context),
      m_resolver(m_io_context), m_local_port(1337) {}

ProxyModule::~ProxyModule() {}

std::string ProxyModule::get_module_name() const {
  const std::string module_name = "Proxy";
  return module_name;
}

void ProxyModule::initialize_proxy(int local_port) {
  try {
    m_local_port = local_port;
    boost::asio::ip::tcp::endpoint endpoint(boost::asio::ip::tcp::v4(),
                                            local_port);
    m_acceptor.open(endpoint.protocol());
    m_acceptor.set_option(boost::asio::ip::tcp::acceptor::reuse_address(true));
    m_acceptor.bind(endpoint);
    m_acceptor.listen();
    BotLogger::getInstance().save_log("Proxy initialized successfully.",
                                      LogLevel::INFO, BotModules::PROXY);
    accept_connection();
  } catch (const std::exception &e) {
    BotLogger::getInstance().save_exception(e, LogLevel::ERROR,
                                            BotModules::PROXY);
  }
}

void ProxyModule::accept_connection() {
  try {
    BotLogger::getInstance().save_log("Accepting connection...", LogLevel::INFO,
                                      BotModules::PROXY);
    m_acceptor.async_accept(m_client_socket, [this](
                                                 boost::system::error_code ec) {
      if (!ec) {
        BotLogger::getInstance().save_log("Connection accepted successfully.",
                                          LogLevel::INFO, BotModules::PROXY);
        handle_client(std::move(m_client_socket));
      } else {
        BotLogger::getInstance().save_log("Failed to accept connection: " +
                                              ec.message(),
                                          LogLevel::ERROR, BotModules::PROXY);
      }
      accept_connection(); // Accept the next connection
    });
  } catch (const std::exception &e) {
    BotLogger::getInstance().save_exception(e, LogLevel::ERROR,
                                            BotModules::PROXY);
  }
}

void ProxyModule::handle_client(boost::asio::ip::tcp::socket client_socket) {
  try {
    BotLogger::getInstance().save_log("Handling client...", LogLevel::INFO,
                                      BotModules::PROXY);
    BotLogger::getInstance().save_log("Creating socket for server...",
                                      LogLevel::TRACE, BotModules::PROXY);
    boost::asio::ip::tcp::socket server_socket(m_io_context);
    boost::asio::ip::tcp::resolver::query query("localhost",
                                                std::to_string(m_local_port));
    boost::asio::ip::tcp::resolver::iterator endpoint_iterator =
        m_resolver.resolve(query);
    boost::asio::connect(server_socket, endpoint_iterator);
    BotLogger::getInstance().save_log("Forwarding data...", LogLevel::TRACE,
                                      BotModules::PROXY);
    auto forward_data = [](boost::asio::ip::tcp::socket &source,
                           boost::asio::ip::tcp::socket &destination) {
      std::vector<char> data(1024);
      boost::system::error_code ec;
      size_t length = source.read_some(boost::asio::buffer(data), ec);
      if (!ec) {
        boost::asio::write(destination, boost::asio::buffer(data, length));
      }
      return !ec;
    };
    while (true) {
      if (!forward_data(client_socket, server_socket) ||
          !forward_data(server_socket, client_socket)) {
        break;
      }
    }
  } catch (const std::exception &e) {
    BotLogger::getInstance().save_exception(e, LogLevel::ERROR,
                                            BotModules::PROXY);
  }
}

void ProxyModule::execute_module(const nlohmann::json &instructions) {
  BotLogger::getInstance().save_log("Executing Proxy module...", LogLevel::INFO,
                                    BotModules::PROXY);
  int local_port = instructions["local_port"];
  initialize_proxy(local_port);
}