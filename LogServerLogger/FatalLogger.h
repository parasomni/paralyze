#pragma once
#include "BaseLogger.h"

class FatalLogger : public BaseLogger {
public:
  FatalLogger(std::map<std::string, std::string> &log_entries,
              Essentials *essentials);
  ~FatalLogger();
  std::string &format_log() override;
};