#!/usr/bin/env bash
#
# IMPORTANT(jeff): This file should always be ran from the project's root
# source tree, i.e.:
#
#   bin/gen_dev-ssl-certs.sh
#

function log_message() {
  local MSG
  MSG=$*

  echo -e ""
  echo -e "${SCRIPT_NAME}: ${MSG}"
  echo -e ""
  return 0
}

function gen_cert_auth_root() {
  log_message "Generating root Certificate Authority (CA) key at ${ROOT_CA_KEY}..."

  # Generate our private root CA key -- no password
  # ${OPENSSL_BIN} genrsa -out ${ROOT_CA_KEY} ${RSA_BITS}

  # Generate our private root CA key -- password-protected
  ${OPENSSL_BIN} genrsa -des3 \
    -passout pass:${ROOT_CA_KEY_PASSPHRASE} \
    -out ${ROOT_CA_KEY} ${RSA_BITS}

  log_message "Generating our root CA certificate at ${ROOT_CA_CERT} "
  log_message "and signing it with ${ROOT_CA_KEY}..."

  # Self-sign our CA root certificate
  ${OPENSSL_BIN} req -x509 -new -nodes \
    -key ${ROOT_CA_KEY} \
    -passin pass:${ROOT_CA_KEY_PASSPHRASE} \
    -out ${ROOT_CA_CERT} \
    -sha512 \
    -days ${ROOT_CA_VALID_DAYS} \
    -subj '/C=US/ST=AR/L=Fort Smith/O=syn.localnet/OU=local dev domain site/CN=syn.localnet/emailAddress=i8degrees@gmail.com'

  # Now, distribute certificate around to your workstations and trusted friends,
  # so that they will know when that the cert is legit and when it is not.
}

function cleanup_certs() {
  if [[ -e $KEYS_DIR ]]; then
    # NOTE(jeff): Clean up the existing environment
    log_message "Removing the existing key set at ${KEYS_DIR}..."
    ${RM_BIN} -rf ${KEYS_DIR}/${KEY_PREFIX}-${KEY_SUFFIX}*
  fi
}

function init_env() {
  # NOTE(jeff): Create new environment...
  log_message "Initializing new key directory at ${KEYS_DIR}..."
  ${MKDIR_BIN} -v ${KEYS_DIR}
}

function gen_certs() {
  CERT_DOMAIN_NAME=$1
  KEY_PREFIX=$2
  KEY_SUFFIX=$3
  SITE_CERT_REQUEST="${KEYS_DIR}/${KEY_PREFIX}-${KEY_SUFFIX}.csr"
  # This key should be kept private!
  SITE_KEY="${KEYS_DIR}/${KEY_PREFIX}-${KEY_SUFFIX}.pem"
  SITE_CERT="${KEYS_DIR}/${KEY_PREFIX}-${KEY_SUFFIX}.crt"

  init_env
  cleanup_env

  # gen_cert_auth_root

  log_message "Generating our HTTPS site key at ${SITE_KEY}..."
  ${OPENSSL_BIN} genrsa \
    -out ${SITE_KEY} ${RSA_BITS}

  # Create the site certificate request; .csr file
  log_message "Creating the site certificate request at ${SITE_CERT_REQUEST}..."
  ${OPENSSL_BIN} req -new \
    -key ${SITE_KEY} \
    -passin pass:${SITE_KEY_PASSPHRASE} \
    -out ${SITE_CERT_REQUEST} \
    -subj "/C=US/ST=AR/L=Fort Smith/O=syn.localnet/OU=local dev domain site/CN=${CERT_DOMAIN_NAME}/emailAddress=i8degrees@gmail.com"

  log_message "Creating HTTPS site certificate with ${ROOT_CA_CERT} and ${ROOT_CA_KEY} at ${SITE_CERT} with its own key at ${SITE_KEY}"
  ${OPENSSL_BIN} x509 -req \
    -in ${SITE_CERT_REQUEST} \
    -CA ${ROOT_CA_CERT} \
    -CAkey ${ROOT_CA_KEY} \
    -passin pass:${ROOT_CA_KEY_PASSPHRASE} \
    -CAcreateserial \
    -out ${SITE_CERT} \
    -days ${SITE_VALID_DAYS} \
    -sha256
}

# ...environment init...

ROOT_CA_KEY_PASSPHRASE="boobiesfuckdev"
SITE_KEY_PASSPHRASE=$ROOT_CA_KEY_PASSPHRASE

SCRIPT_NAME=$(basename "${0}")
PWD=$(pwd)
KEYS_DIR="${PWD}/keys/dev"
MKDIR_BIN="/bin/mkdir"
RM_BIN="/bin/rm"
OPENSSL_BIN="/usr/bin/openssl"

OPENSSL_CONFIG="${PWD}/bin/openssl.cnf"
RSA_BITS=4096 # 2048 or 4096

# This key should be kept private!
ROOT_CA_KEY="${HOME}/Projects/naughty.git/keys/dev/caroot.pem"
ROOT_CA_CERT="${HOME}/Projects/naughty.git/keys/dev/caroot.crt"

SITE_VALID_DAYS=365 # 1 year

NUM_ARGS=$#

if [[ $NUM_ARGS -lt 3 ]]; then
  echo -e "\n\tUsage:\n\t\t ${SCRIPT_NAME} [CERT_DOMAIN_SITE_NAME] [FILE_PREFIX] [FILE_SUFFIX]"
  echo -e "\Upon successful site certificate files generation, said files will be at ${KEYS_DIR}"
  # exit 0
fi

# gen_certs $1 $2 $3

gen_certs notes.syn.localnet notes-wiki syn-localnet
gen_certs notes.dev notes-wiki local
gen_certs testme.justfielding.com notes-wiki testme-justfielding.com
gen_certs notes.justfielding.com notes-wiki notes-justfielding.com
gen_certs 127.0.0.1 notes-wiki localhost
