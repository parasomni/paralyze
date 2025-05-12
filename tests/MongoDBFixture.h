#pragma once
#include "IfcEssentials.h"
#include <iostream>
#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>
#include <nlohmann/json.hpp>

struct MongoDBFixture {
  static mongocxx::instance instance;
  nlohmann::json cm_config =
      IfcEssentials::getInstance().get_json_dump_from_file(
          "../../configs/config_module.json");
  mongocxx::client client{
      mongocxx::uri{cm_config["general"]["uri"].get<std::string>()}};

  MongoDBFixture() {
    std::cout << "Beginning of MongoDBFixture" << std::endl;
    // Drop the test database to ensure a clean state
    client[std::string(cm_config["bot_configs"]["name"])].drop();
    std::cout << "Dropped test database" << std::endl;
  }

  ~MongoDBFixture() {
    // Drop the test database to clean up
    client[std::string(cm_config["bot_configs"]["name"])].drop();
    std::cout << "Dropped test database" << std::endl;
  }
};