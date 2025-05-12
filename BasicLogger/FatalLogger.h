#pragma once
#include "BaseLogger.h"

class FatalLogger : public BaseLogger {
public:
  FatalLogger(const std::string &server_address, int port);
  ~FatalLogger();
  std::string &format_log() override;

private:
  boost::asio::io_context m_io_context;
  boost::asio::ip::tcp::socket m_logger_socket;
};