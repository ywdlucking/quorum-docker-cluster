#!/bin/bash


#bash <root> <number_of_nodes> <docker_network_id>
#constellations launch on port 9000, 9001, 9002, ... 
#quorum nodes launch on ports <p2p: 22000, raft:50400>, <22001, 50401>, ...

createNetworkIfNotExisting(){
  docker inspect $docker_network_id 1>> /dev/null 
  if [ $? -ne 0 ];then
    echo "docker network id $docker_network_id is not existing, create it"
    docker network create $docker_network_id  
  fi
  docker_network_ip=`docker inspect -f "{{ (index .IPAM.Config 0).Gateway }}" $docker_network_id`
}

initOneQuorumNode(){
  local quorum_dir=$root/qdata$1/quorum
  echo "start init Quorum node"
  mkdir -p $quorum_dir && cd $quorum_dir

  echo "generate nodekey for quorum node"
  $BOOTNODE -genkey nodekey 

#  echo "setup one segment of compose file"
#  setupOneQuorumDockerComposeFile $1

  echo "finish init Quorum node" 
}




initOneConstellation(){
  local nodeid=$1 
  local constellation_dir=$root/qdata$nodeid/constellation
  echo "start init constellation dir"
  mkdir -p $constellation_dir/keys && cd $constellation_dir/keys 
 
  echo "generate constellation key pairs" 
  $CONSTELLATION --generatekeys=constellation$nodeid 
  
  echo "generate constellation conf file"
  setupConstellationConf $nodeid
   
  echo "finish init constellation dir"
}

setupConstellationConf(){
  local nodeid=$1
  local constellation_name=constellation$nodeid
  local constellation_ip=$constellation_name
  local constellation_work_dir="\/etc\/constellation"
  local constellation_port=9000
  local constellation_bootnode_url="http:\/\/constellation00:9000"
  local constellation_file=$root/qdata$nodeid/constellation/constellation.conf 

  cat $script_dir/constellation_template.conf > $constellation_file 
  sed -i "s/#ConstellationIP#/${constellation_ip}/g" $constellation_file 
  sed -i "s/#ConstellationWorkDir#/${constellation_work_dir}/g" $constellation_file 
  sed -i "s/#ConstellationName#/${constellation_name}/g" $constellation_file 
  sed -i "s/#ConstellationBootnodeUrl#/${constellation_bootnode_url}/g" $constellation_file 
  sed -i "s/#ConstellationPort#/${constellation_port}/g" $constellation_file 
}

setupOneQuorumDockerComposeFile(){
  local nodeid=$1
  
  local quorum_segment_file=$root/qdata$id/quorum/quorum_compose.yml 
  cat $script_dir/quorum_compose_template.yml > $quorum_segment_file 

  sed -i "s/#QuorumName#/quorum$nodeid/g" $quorum_segment_file 
  sed -i "s/#QuorumRaftPort#/504$nodeid/g" $quorum_segment_file  
  sed -i "s/#QuorumPort#/220$nodeid/g" $quorum_segment_file 
  sed -i "s/#QuorumRpcPort#/230$nodeid/g" $quorum_segment_file 
  sed -i "s/#ConstellationName#/constellation/g" $quorum_segment_file 
  sed -i "s/#NodeName#/qdata$nodeid/g" $quorum_segment_file 
}

setupOneConstellationDockerComposeFile(){
  local nodeid=$1

  local constellation_segment_file=$root/qdata$id/constellation/constellation_compose.yml
  cat $script_dir/constellation_compose_template.yml > $constellation_segment_file

  sed -i "s/#ConstellationPort#/90$nodeid/g" $constellation_segment_file
  sed -i "s/#ConstellationName#/constellation$nodeid/g" $constellation_segment_file
  sed -i "s/#NodeName#/qdata$nodeid/g" $constellation_segment_file
}


#global variables
CONSTELLATION=~/work/constellation/constellation-0.1.0-ubuntu1604/constellation-node
GETH=~/work/quorum/build/bin/geth
BOOTNODE=~/work/quorum/build/bin/bootnode

script_dir=`pwd`

root=$1
N=$2
docker_network_id=$3

if [ ! -d $root ]; then
  mkdir $root
fi 

createNetworkIfNotExisting

echo "[" >> $root/static-nodes.json
for ((i=0;i<N;++i)); do
  id=`printf "%02d" $i`
  initOneQuorumNode $id
  initOneConstellation $id
  
  enode_id=`$BOOTNODE -writeaddress -nodekey $root/qdata$id/quorum/nodekey` 
  enode_url="enode://$enode_id@$docker_network_ip:220$id?raftport=504$id"
  
  echo "\"${enode_url}\"" >> $root/static-nodes.json
  if ((i<N-1)); then
    echo "," >> $root/static-nodes.json
  fi 
done

echo "]" >> $root/static-nodes.json


#setup the whole docker compose file

cat $script_dir/compose_header_template.yml > $root/docker-compose-quorum.yml
cat $script_dir/compose_header_template.yml > $root/docker-compose-constellation.yml
sed -i "s/#DockerNetworkId#/$docker_network_id/g" $root/docker-compose-quorum.yml
sed -i "s/#DockerNetworkId#/$docker_network_id/g" $root/docker-compose-constellation.yml

for ((i=0;i<N;++i)); do
  id=`printf "%02d" $i`
  echo "setup one segment of compose file"
  setupOneQuorumDockerComposeFile $id
  setupOneConstellationDockerComposeFile $id
  
  cat $root/qdata$id/constellation/constellation_compose.yml >> $root/docker-compose-constellation.yml 
  cat $root/qdata$id/quorum/quorum_compose.yml >> $root/docker-compose-quorum.yml
 
  #if use raft,quorum need static-nodes.json file  
  cp $root/static-nodes.json $root/qdata$id/quorum/
done


