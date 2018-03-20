#!/bin/bash

set -u
set -e

log(){
  echo "$1"
}

#/etc/quorum/conf.d
QUORUM_DIR=/etc/quorum

GLOBAL_ARGS="--raft --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum --emitcheckpoints"

GENESIS_FILE="$QUORUM_DIR/genesis.json"
#CONSTELLATION_FILE="$QUORUM_DIR/constellation.conf"

if [ ! -e "$GENESIS_FILE" ];then
   log "INFO: $GENESIS_FILE is not existed, use the default /genesis.json"
   GENESIS_FILE=/genesis.json
fi

#check if contains static-nodes.json and permissioned-nodes.json
if [ -e "$QUORUM_DIR/static-nodes.json" ];then
   log "INFO: specify static-nodes.json"
else 
   log "INFO: static-nodes.json is not existed, created an empty json file."
   echo "[]" > $QUORUM_DIR/static-nodes.json
fi

if [ -e "$QUORUM_DIR/permissioned-nodes.json" ];then
   log "INFO: specify $QUORUM_DIR/permissioned-nodes.json"
else
   log "INFO: $QUORUM_DIR/permissioned-nodes.json is not specified"
fi

#if [ ! -e "$CONSTELLATION_FILE" ];then
#   log "INFO: $CONSTELLATION_FILE is not existed, use the default /constellation.conf"
#   CONSTELLATION_FILE=/constellation.conf
#fi

geth --datadir $QUORUM_DIR init $GENESIS_FILE

#export PRIVATE_CONFIG="$CONSTELLATION_FILE"

FINAL_ARGS="--datadir $QUORUM_DIR $GLOBAL_ARGS --raftport 8070 --rpcport 8080 --port 8090"
#nohup geth --datadir $QUORUM_DIR $GLOBAL_ARGS --raftport 8070 --rpcport 8080 --port 8090 2>> $LOG_DIR/quorum-node.log &

echo "$@" $FINAL_ARGS

exec "$@" $FINAL_ARGS
