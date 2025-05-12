#!/bin/bash
set -e

mkdir -p pki/root

echo "[*] Generating Root EC private key..."
openssl ecparam -name prime256v1 -genkey -noout -out pki/root/root.key

echo "[*] Creating self-signed Root CA certificate..."
openssl req -x509 -new -key pki/root/root.key \
  -sha256 -days 3650 -out pki/root/root.crt \
  -subj "/C=US/ST=CA/L=Internal/O=PKI/OU=RootCA/CN=RootCA" \
  -extensions v3_ca \
  -config <(cat <<-EOF
    [ req ]
    distinguished_name = dn
    x509_extensions = v3_ca
    prompt = no

    [ dn ]
    CN = RootCA

    [ v3_ca ]
    basicConstraints = CA:TRUE
    keyUsage = keyCertSign, cRLSign
    subjectKeyIdentifier = hash
EOF
)

echo '1000' > pki/root/root.srl
echo "[✓] Root CA generated in pki/root/"
