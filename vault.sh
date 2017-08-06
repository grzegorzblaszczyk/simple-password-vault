#!/bin/bash 

RM=`which rm`
SEVEN_ZIP=`which 7z`
TOUCH=`which touch`
VAULT_EDITOR=`which vim`

### DO NOT EDIT BELOW THIS LINE ###

DEFAULT_VAULT_FILE_SCHEME="${HOME}/.vault"
DEFAULT_SECURE_VAULT_FILE="${DEFAULT_VAULT_FILE_SCHEME}.7z"
DEFAULT_RAW_VAULT_FILE="${DEFAULT_VAULT_FILE_SCHEME}.txt"

VAULT_FILE=""
DATA_FILE=""

if [ "x$1" == "x--help" ]; then
  echo ""
  echo "Usage:"
  echo "$0 [path_to_vault_file]"
  echo ""
  exit 1
fi

if [ "x$1" == "x" ]; then
  VAULT_FILE=${DEFAULT_SECURE_VAULT_FILE}
  DATA_FILE=${DEFAULT_RAW_VAULT_FILE}
else
  VAULT_FILE="$1"
  DATA_FILE="${VAULT_FILE}_extracted"
fi

if [ "x${SEVEN_ZIP}" == "x" ]; then
  echo "ERROR: You need to install 7z!"
  exit 1
fi

if [ "x${VAULT_EDITOR}" == "x" ]; then
  echo "ERROR: You need to install your vault editor!"
  exit 1
fi

echo "Using vault file: ${VAULT_FILE}..."

if [ ! -f ${VAULT_FILE} ]; then
  echo "Creating new vault ${VAULT_FILE}..."
  ${TOUCH} ${DATA_FILE}
else
  ${SEVEN_ZIP} e -y -o${HOME} ${VAULT_FILE} 
fi

RETURN_VALUE="$?"
if [ "${RETURN_VALUE}" != "0" ]; then
  echo "ERROR: Cannot extract raw vault file!"
  exit 1
else
  echo "Opening ${VAULT_FILE}..."
fi

${VAULT_EDITOR} ${DATA_FILE}
${SEVEN_ZIP} u -p ${VAULT_FILE} ${DATA_FILE}
${RM} ${DATA_FILE}

