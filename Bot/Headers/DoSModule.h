#pragma once
#include "IModule.h"
#include <boost/asio.hpp>

class DoSModule : public IModule {
public:
  DoSModule();
  ~DoSModule();
  std::string get_module_name() const override;
  void execute_module(const nlohmann::json &instructions) override;

private:
  void connect_to_target();
  void send_data_async(std::shared_ptr<boost::asio::ip::tcp::socket> socket);
  void stop_attack();
  void shutdown_module();
  boost::asio::io_context m_io_context;
  boost::asio::ip::tcp::resolver m_resolver;
  std::vector<std::shared_ptr<boost::asio::ip::tcp::socket>> m_sockets;
  boost::asio::steady_timer m_timer;
  std::string m_target_ip;
  int m_target_port;
  std::atomic<bool> m_stop_attack;
};