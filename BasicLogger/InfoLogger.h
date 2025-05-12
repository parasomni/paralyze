#pragma once
#include "BaseLogger.h"
#include <boost/asio.hpp>
#include <string>

class InfoLogger : public BaseLogger {
public:
  InfoLogger(const std::string &server_address, int port);
  ~InfoLogger();
  std::string &format_log() override;

private:
  boost::asio::io_context m_io_context;
  boost::asio::ip::tcp::socket m_logger_socket;
};