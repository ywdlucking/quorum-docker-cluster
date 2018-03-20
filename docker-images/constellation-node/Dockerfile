# This will build the witness_node in a docker image based on ubuntu:16.04

FROM ubuntu:16.04
MAINTAINER Wang Lei <leiwang@wxblockchain.com>

ADD sources.list /etc/apt/sources.list

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

RUN mkdir /etc/constellation

COPY constellation.conf /
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh # backwards compat

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"] 

EXPOSE 9000

CMD ["constellation-node"]

