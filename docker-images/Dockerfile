# This will build the witness_node in a docker image based on ubuntu:16.04

FROM ubuntu:16.04
MAINTAINER Wang Lei <leiwang@wxblockchain.com>

ADD sources.list /etc/apt/sources.list

#
RUN apt-get update

# install build deps
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ethereum/ethereum && \
    apt-get update && \
    apt-get install -y build-essential unzip libdb-dev libleveldb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk	

# install constellation
ENV CONSTELLATION_REL="constellation-0.2.0-ubuntu1604"	
RUN apt-get update && \
    apt-get install -y wget
	
RUN wget -q "http://qa-wxtrust-jws.wancloud.io/${CONSTELLATION_REL}.tar.xz" && \
    tar xfJ "${CONSTELLATION_REL}.tar.xz" && \
	cp "${CONSTELLATION_REL}/constellation-node" /usr/local/bin && \
	chmod 0755 /usr/local/bin/constellation-node && \
	rm -rf "${CONSTELLATION_REL}"

# install golang
ENV GO_REL=go1.7.3.linux-amd64.tar.gz
RUN wget -q "http://qa-wxtrust-jws.wancloud.io/${GO_REL}" && \
    tar xfz "${GO_REL}" && \
	mv go /usr/local/go && \
	rm -f "${GO_REL}" 
	
# make/install quorum
RUN apt-get update && \
    apt-get install -y git-core 
	
RUN	git clone https://github.com/jpmorganchase/quorum.git 

ENV PATH ${PATH}:/usr/local/go/bin

RUN cd quorum && \
    git checkout tags/v2.0.0 && \
	make all && \
	cp build/bin/geth /usr/local/bin && \
	cp build/bin/bootnode /usr/local/bin && \
	cd ..

RUN wget -q http://qa-wxtrust-jws.wancloud.io/porosity && \
    mv porosity /usr/local/bin && \
	chmod 0755 /usr/local/bin/porosity	

CMD ["/bin/bash"]
