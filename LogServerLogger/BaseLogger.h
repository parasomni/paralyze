#pragma once
#include "Essentials.h"
#include <boost/asio.hpp>
#include <map>
#include <string>

class BaseLogger {
public:
  BaseLogger(std::map<std::string, std::string> &log_entries,
             Essentials *essentials);
  ~BaseLogger();

  const std::map<std::string, std::string> &get_log_entries() const;
  void set_log_entries(const std::map<std::string, std::string> &log_entries);
  void log_message(const std::string &message);
  virtual std::string format_log() const;

private:
  Essentials *m_essentials;
  std::map<std::string, std::string> m_log_entries;
};