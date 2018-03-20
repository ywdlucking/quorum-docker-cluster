#!/bin/bash

set -u
set -e

log(){
  echo "$@"
}

# usage: check_env VAR [DEFAULT]
#     ie: check_env 'URL' 'http://localhost:8080'
check_env(){
  local var="$1"
  local defaultVal="$2"
  
  local val = "${defaultVal}"
  if [ "${!var}" ]; then
    val = "${!var}"
  elif [ "X${defaultVal}" == "X" ]; then
    echo <&2 "error: $var is not defained, and it don't has default value"
	exit 1
  fi
  
  export "$var"="$val" 
}

CONSTELLATION_FILE="/etc/constellation/constellation.conf"

#check_env "URL" 
#check_env "PORT"
#check_env "SOCKET"
#check_env "OTHER_NODES"
#check_env "PUBLIC_KEYS"
#check_env "PRIVATE_KEYS"

if [ ! -e "$CONSTELLATION_FILE" ];then
   log "INFO: $CONSTELLATION_FILE is not existed, use the default /constellation.conf"
   CONSTELLATION_FILE=/constellation.conf
fi

ARGS=""
if [ "${PUBLIC_KEYS:-}" -a "${PRIVATE_KEYS:-}" ]; then
  ARGS="$ARGS --publickeys=${PUBLIC_KEYS} --privatekeys=${PRIVATE_KEYS}"
fi

echo $@ $ARGS $CONSTELLATION_FILE
exec "$@" $ARGS $CONSTELLATION_FILE
