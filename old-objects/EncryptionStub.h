#pragma once
#include <cstddef> // for std::byte
#include <vector>

class EncryptionStub {
private:
  unsigned char m_key[32];
  const int m_block_size;

public:
  EncryptionStub(const unsigned char *key);
  void set_key(const unsigned char *key);
  std::vector<std::byte> encrypt(const std::vector<std::byte> &plaintext);
  std::vector<std::byte> decrypt(const std::vector<std::byte> &ciphertext);
};