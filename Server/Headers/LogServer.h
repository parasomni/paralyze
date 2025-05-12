#pragma once
#include "BaseServer.h"

class LogServer : public BaseServer {
  boost::asio::io_context::work m_work;
  std::vector<std::shared_ptr<boost::asio::io_context>> m_io_contexts;
  std::vector<std::thread> m_threads;
  std::unique_ptr<boost::asio::ip::tcp::acceptor> m_acceptor;
  std::unique_ptr<boost::asio::ip::tcp::socket> m_log_socket;
  std::string m_config_file;

  LogServer(const std::string &config_file);
  void start_server() override;
  void react_to_config_update() override;
  std::pair<std::vector<unsigned char>, int> setup_encryption() override;
  void do_accept() override;
  void handle_client(
      std::shared_ptr<boost::asio::ip::tcp::socket> client_socket) override;
};