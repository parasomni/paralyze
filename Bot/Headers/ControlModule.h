#pragma once
#include "IModule.h"
#include "NetworkModule.h"
#include <memory>

class ControlModule : public NetworkModule, public IModule {
public:
  ControlModule(const std::string &server_address, int server_port);
  ~ControlModule();
  std::string get_module_name() const override { return "control"; }
  nlohmann::json fetch_instructions();
  void evaluate_basic_instructions(const nlohmann::json &instructions);
  void evaluate_sleep(const nlohmann::json &instructions);
  void evaluate_module(const nlohmann::json &instructions);
  void random_sleep();
  void wait_until_time(const std::string &time);
  void execute_module(const nlohmann::json &instructions) override;
  void start_module();
  void register_module(std::shared_ptr<IModule> module);
  std::vector<std::shared_ptr<IModule>> get_modules() const;

private:
  std::vector<std::shared_ptr<IModule>> m_modules;
};