#pragma once
#include "Essentials.h"
#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>
#include <mongocxx/uri.hpp>
#include <nlohmann/json.hpp>

class ConfigModule {
private:
  ConfigModule() = default;
  ConfigModule(const ConfigModule &) = delete;
  ConfigModule &operator=(const ConfigModule &) = delete;
  static ConfigModule instance;
  mongocxx::instance m_instance;
  mongocxx::client m_client;
  nlohmann::json m_config;
  nlohmann::json m_init_instructions;

public:
  static ConfigModule &getInstance() { return instance; }
  void init_config_module(const nlohmann::json &config);

  // getters
  nlohmann::json get_bot_config(const std::string &uuid);
  std::string get_init_token();
  nlohmann::json get_instruction(const std::string &instruction_name);

  // setters
  void set_bot_instructions(const std::string &uuid,
                            const nlohmann::json &instruction_name);
  void set_init_token(const std::string &token);
};