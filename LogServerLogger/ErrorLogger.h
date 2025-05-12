#pragma once
#include "BaseLogger.h"

class ErrorLogger : public BaseLogger {
public:
  ErrorLogger(std::map<std::string, std::string> &log_entries,
              Essentials *essentials);
  ~ErrorLogger();
  std::string &format_log() override;
};