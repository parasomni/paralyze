#ifndef MOCKMODULE_H
#define MOCKMODULE_H

#include "IModule.h"

class MockModule : public IModule {
public:
  void execute_module(const nlohmann::json &instructions) override {
    // Mock implementation
  }

  std::string get_module_name() const override { return "mock"; }
};

#endif // MOCKMODULE_H