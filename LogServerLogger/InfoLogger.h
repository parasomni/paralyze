#pragma once
#include "BaseLogger.h"

class InfoLogger : public BaseLogger {
public:
  InfoLogger(std::map<std::string, std::string> &log_entries,
             Essentials *essentials);
  ~InfoLogger();
  std::string &format_log() override;
};