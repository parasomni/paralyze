#pragma once
#include "BotEssentials.h"
#include <boost/beast/http.hpp>
#include <openssl/pem.h>

class NetworkEssentials {
private:
  NetworkEssentials() = default;
  NetworkEssentials(const NetworkEssentials &) = delete;
  NetworkEssentials &operator=(const NetworkEssentials &) = delete;
  static NetworkEssentials instance;

public:
  static NetworkEssentials &getInstance() { return instance; }
  X509 *load_certificate(const char *cert_file);
  void write_certificate_to_file(X509 *cert, const std::string &cert_file);
  X509 *bytes_to_x509(const std::vector<std::byte> &data);
  std::vector<std::byte> X509_REQ_to_bytes(X509_REQ *csr);
  EVP_PKEY *load_private_key(const char *key_file);
};