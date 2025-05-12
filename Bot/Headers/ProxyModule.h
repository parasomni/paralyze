#pragma once
#include "IModule.h"
#include <boost/asio.hpp>

class ProxyModule : public IModule {
public:
  ProxyModule();
  ~ProxyModule();
  void accept_connection();
  void handle_client(boost::asio::ip::tcp::socket client_socket);
  void enable_port_forwarding();
  void initialize_proxy(int local_port);
  std::string get_module_name() const override;
  void execute_module(const nlohmann::json &instructions) override;

private:
  boost::asio::io_context m_io_context;
  boost::asio::ip::tcp::resolver m_resolver;
  boost::asio::ip::tcp::acceptor m_acceptor;
  boost::asio::ip::tcp::socket m_client_socket;
  int m_local_port;
};