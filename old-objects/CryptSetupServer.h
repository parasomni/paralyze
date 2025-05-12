#include "EncryptionStub.h"
#include "Essentials.h"

class CryptSetup {
private:
  CryptSetup() = default;
  CryptSetup(const CryptSetup &) = delete;
  CryptSetup &operator=(const CryptSetup &) = delete;
  static CryptSetup instance;

public:
  static CryptSetup &getInstance() { return instance; }
  bool setup_encryption_stub(boost::asio::ip::tcp::socket &tcp_socket,
                             EncryptionStub &stub, bool is_server);
  const unsigned char *
  setup_encryption_client(const boost::asio::ip::tcp::socket &socket);
  const unsigned char *
  setup_encryption_server(const boost::asio::ip::tcp::socket &socket);
};