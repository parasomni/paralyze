#include "IfcLogger.h"
#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>
#include <mongocxx/uri.hpp>
#include <nlohmann/json.hpp>

class ConfigWriter {
private:
  mongocxx::instance m_instance;
  mongocxx::client m_client;
  nlohmann::json m_config;

public:
  ConfigWriter(const nlohmann::json &config);
  ~ConfigWriter();
  void react_to_config_update(const nlohmann::json &config);
  void write_config_to_db(const std::string &db, const std::string &collection,
                          const std::string &config_name,
                          const nlohmann::json &config);
};