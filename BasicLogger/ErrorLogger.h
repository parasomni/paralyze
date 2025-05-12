#pragma once
#include "BaseLogger.h"

class ErrorLogger : public BaseLogger {
  boost::asio::io_context m_io_context;
  boost::asio::ip::tcp::socket m_logger_socket;
  ErrorLogger(const std::string &server_address, int port);
  ~ErrorLogger();
  std::string &format_log() override;
};