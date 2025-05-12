#pragma once
#include "BaseLogger.h"

class WarnLogger : public BaseLogger {
public:
  WarnLogger(std::map<std::string, std::string> &log_entries,
             Essentials *essentials);
  ~WarnLogger();
  std::string &format_log() override;
};