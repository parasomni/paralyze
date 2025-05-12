#pragma once
#include "BaseLogger.h"

class DebugLogger : public BaseLogger {
public:
  DebugLogger(std::map<std::string, std::string> &log_entries,
              Essentials *essentials);
  ~DebugLogger();
  std::string &format_log() override;
};