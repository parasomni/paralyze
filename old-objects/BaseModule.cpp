#include "BaseModule.h"
#include "BotLogger.cpp"

BaseModule::BaseModule() : m_crypt_stub(nullptr) {}

BaseModule::~BaseModule() {}

EncryptionStub *BaseModule::get_crypt_stub() const { return m_crypt_stub; }

void BaseModule::initialize_crypt_stub(unsigned char *key) {
  m_crypt_stub = new EncryptionStub(key);
}
