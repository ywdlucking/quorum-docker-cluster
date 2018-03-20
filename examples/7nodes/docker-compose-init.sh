#!/bin/bash
set -u
set -e

echo "[*] Cleaning up temporary data directories"
rm -rf qdata
mkdir -p qdata/logs

echo "[*] Configuring node 1 (permissioned)"
mkdir -p qdata/dd1/constellation/keys qdata/dd1/quorum-node/{keystore,geth}
cp permissioned-nodes.json qdata/dd1/quorum-node/static-nodes.json
cp permissioned-nodes.json qdata/dd1/quorum-node/
cp keys/key1 qdata/dd1/quorum-node/keystore
cp raft/nodekey1 qdata/dd1/quorum-node/geth/nodekey
cp tm1.conf qdata/dd1/quorum-node/constellation.conf
cp passwords.txt qdata/dd1/quorum-node/
cp script1.js qdata/dd1/quorum-node/

cp tm1.conf qdata/dd1/constellation/constellation.conf
cp keys/tm1.pub qdata/dd1/constellation/keys
cp keys/tm1.key qdata/dd1/constellation/keys

echo "[*] Configuring node 2 (permissioned)"
mkdir -p qdata/dd2/constellation/keys qdata/dd2/quorum-node/{keystore,geth}
cp permissioned-nodes.json qdata/dd2/quorum-node/static-nodes.json
cp permissioned-nodes.json qdata/dd2/quorum-node/
cp keys/key2 qdata/dd2/quorum-node/keystore
cp keys/key3 qdata/dd2/quorum-node/keystore
cp raft/nodekey2 qdata/dd2/quorum-node/geth/nodekey
cp tm2.conf qdata/dd2/quorum-node/constellation.conf

cp tm2.conf qdata/dd2/constellation/constellation.conf
cp keys/tm2.pub qdata/dd2/constellation/keys
cp keys/tm2.key qdata/dd2/constellation/keys

echo "[*] Configuring node 3 (permissioned)"
mkdir -p qdata/dd3/constellation/keys qdata/dd3/quorum-node/{keystore,geth}
cp permissioned-nodes.json qdata/dd3/quorum-node/static-nodes.json
cp permissioned-nodes.json qdata/dd3/quorum-node/
cp raft/nodekey3 qdata/dd3/quorum-node/geth/nodekey
cp tm3.conf qdata/dd3/quorum-node/constellation.conf

cp tm3.conf qdata/dd3/constellation/constellation.conf
cp keys/tm3.pub qdata/dd3/constellation/keys
cp keys/tm3.key qdata/dd3/constellation/keys

echo "[*] Configuring node 4 (permissioned)"
mkdir -p qdata/dd4/constellation/keys qdata/dd4/quorum-node/{keystore,geth}
cp permissioned-nodes.json qdata/dd4/quorum-node/static-nodes.json
cp permissioned-nodes.json qdata/dd4/quorum-node/
cp keys/key4 qdata/dd4/quorum-node/keystore
cp raft/nodekey4 qdata/dd4/quorum-node/geth/nodekey
cp tm4.conf qdata/dd4/quorum-node/constellation.conf

cp tm4.conf qdata/dd4/constellation/constellation.conf
cp keys/tm4.pub qdata/dd4/constellation/keys
cp keys/tm4.key qdata/dd4/constellation/keys

echo "[*] Configuring node 5"
mkdir -p qdata/dd5/constellation/keys qdata/dd5/quorum-node/{keystore,geth}
cp permissioned-nodes.json qdata/dd5/quorum-node/static-nodes.json
cp keys/key5 qdata/dd5/quorum-node/keystore
cp raft/nodekey5 qdata/dd5/quorum-node/geth/nodekey
cp tm5.conf qdata/dd5/quorum-node/constellation.conf

cp tm5.conf qdata/dd5/constellation/constellation.conf
cp keys/tm5.pub qdata/dd5/constellation/keys
cp keys/tm5.key qdata/dd5/constellation/keys

echo "[*] Configuring node 6"
mkdir -p qdata/dd6/constellation/keys qdata/dd6/quorum-node/{keystore,geth}
cp permissioned-nodes.json qdata/dd6/quorum-node/static-nodes.json
cp raft/nodekey6 qdata/dd6/quorum-node/geth/nodekey
cp tm6.conf qdata/dd6/quorum-node/constellation.conf

cp tm6.conf qdata/dd6/constellation/constellation.conf
cp keys/tm6.pub qdata/dd6/constellation/keys
cp keys/tm6.key qdata/dd6/constellation/keys

echo "[*] Configuring node 7"
mkdir -p qdata/dd7/constellation/keys qdata/dd7/quorum-node/{keystore,geth}
cp permissioned-nodes.json qdata/dd7/quorum-node/static-nodes.json
cp raft/nodekey7 qdata/dd7/quorum-node/geth/nodekey
cp tm7.conf qdata/dd7/quorum-node/constellation.conf

cp tm7.conf qdata/dd7/constellation/constellation.conf
cp keys/tm7.pub qdata/dd7/constellation/keys
cp keys/tm7.key qdata/dd7/constellation/keys
