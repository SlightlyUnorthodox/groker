#!/bin/sh

mkdir -p ~/lemon
cd ~/lemon

# Download LEMON graph library version 1.2.3 and unzip
wget -q "http://lemon.cs.elte.hu/pub/sources/lemon-1.2.3.tar.gz" -O "lemon.tar.gz"
tar xvzf "lemon.tar.gz"

# Step into un-tarred lemon dir
cd ~/lemon/lemon-1.2.3


# Run lemon configuration and install
./configure

# Run make and install
make
#make check # Dependency bug in lemon 1.2.3
make install 