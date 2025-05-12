#pragma once
#include "BaseLogger.h"
#include <boost/asio.hpp>
#include <string>

class DebugLogger : public BaseLogger {
public:
  DebugLogger(const std::string &server_address, int port);
  ~DebugLogger();
  std::string &format_log() override;

private:
  boost::asio::io_context m_io_context;
  boost::asio::ip::tcp::socket m_logger_socket;
};