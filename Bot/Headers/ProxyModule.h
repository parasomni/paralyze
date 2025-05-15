#pragma once

#include "IModule.h"
#include <boost/asio.hpp>
#include <memory>
#include <string>
#include <thread>

class ProxyModule : public IModule {
public:
  ProxyModule();
  ~ProxyModule();

  std::string get_module_name() const override;
  void execute_module(const nlohmann::json &instructions) override;

private:
  void initialize_proxy(int local_port, const std::string &target_host, int target_port);
  void accept_connection();
  void handle_client(std::shared_ptr<boost::asio::ip::tcp::socket> client_socket);
  void start_forwarding(std::shared_ptr<boost::asio::ip::tcp::socket> source,
                        std::shared_ptr<boost::asio::ip::tcp::socket> destination);

  std::shared_ptr<boost::asio::io_context> m_io_context;
  std::shared_ptr<boost::asio::ip::tcp::resolver> m_resolver;
  boost::asio::ip::tcp::acceptor m_acceptor;
  std::thread m_worker_thread;

  std::string m_target_host;
  int m_target_port;
  int m_local_port;
};
