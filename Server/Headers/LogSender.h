#pragma once
#include "Essentials.h"

class LogSender {
private:
  std::string m_server_address;
  int m_server_port;
  boost::asio::io_context m_io_context;
  boost::asio::ip::tcp::socket m_logger_socket;

protected:
  EncryptionStub *m_crypt_stub;

public:
  LogSender(const std::string &server_address, int port);
  ~LogSender();
  const std::string &get_server_address() const;
  int get_port() const;
  void set_server_address(const std::string &server_address);
  void set_server_port(int server_port);
  void send_log_to_server(const std::vector<std::byte> &log_data);
  void initialize_crypt_stub(const unsigned char *key);
  bool setup_encryption();
  void start_log_sender();
};