#!/bin/sh

mkdir -p ~/websocketpp
cd ~/websocketpp

# Get websocketpp library and unzip
wget -q https://github.com/zaphoyd/websocketpp/archive/experimental.zip -O websocketpp.zip
unzip -o websocketpp.zip

# Copying websocketpp to /usr/include
cp -r ~/websocketpp/websocketpp-experimental/websocketpp /usr/include/
