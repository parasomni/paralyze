#include "BotEssentials.h"
#include "EncryptionStub.h"

class CryptSetup {
private:
  CryptSetup() = default;
  CryptSetup(const CryptSetup &) = delete;
  CryptSetup &operator=(const CryptSetup &) = delete;
  static CryptSetup instance;

public:
  static CryptSetup &getInstance() { return instance; }
  bool setup_encryption_stub(boost::asio::ip::tcp::socket &tcp_socket,
                             EncryptionStub &stub);
  const unsigned char *
  setup_encryption_bot(const boost::asio::ip::tcp::socket &socket);
};