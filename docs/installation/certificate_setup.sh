#!/bin/bash
echo "[i] Setting up servers"
echo "[i] Generating private key"
openssl ecparam -name prime256v1 -genkey -noout -out cs_pk.key
echo "[i] Serializing private key to pem format"
openssl ec -in cs_pk.key -out cs_pk.pem
echo "[i] Self signing private key for testing"
openssl req -new -key cs_pk.key -out cs_pk.csr
openssl req -x509 -key cs_pk.key -in cs_pk.csr -out cs_cert.crt -days 365
echo "[i] Extracting public key from private key"
openssl ec -in cs_pk.key -pubout -out cd_pub.pem
echo "[i] Creating temporary DH file"
openssl dhparam -out dh_tmp.pem 2048
echo "[i] Server setup finished"
