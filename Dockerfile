FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libboost-all-dev \
    libzmq3-dev \
    libdb-dev libdb++-dev \
    curl \
    gnupg \
    gcc \
    g++ \
    make \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt install -y nodejs \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y libminiupnpc-dev
RUN apt-get update && apt-get install -y libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils

RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.65.1 /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.54.0

ENV APP_HOME /home
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN npm -g config set user root
RUN npm -g install bitcore@4.1.0

RUN ln -s /usr/lib/x86_64-linux-gnu/libminiupnpc.so.10 /usr/lib/x86_64-linux-gnu/libminiupnpc.so.8

RUN bitcore create bchnode

COPY bch-node/bch-release/bin/bitcoincashd ./

COPY bch-node/data/bitcoin.conf ./data/bitcoin.conf
COPY bch-node/bitcore-node.json ./bitcore-node.json

EXPOSE 8332 3001 28332

ENTRYPOINT bitcored