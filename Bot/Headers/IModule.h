#pragma once
#include <nlohmann/json.hpp>
#include <string>

class IModule {
public:
  virtual std::string get_module_name() const = 0;
  virtual void execute_module(const nlohmann::json &instructions) = 0;
  virtual ~IModule() = default;
};