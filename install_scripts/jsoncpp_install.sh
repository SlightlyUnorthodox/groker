#!/bin/sh

mkdir -p ~/jsoncpp
cd ~/jsoncpp

git clone https://github.com/open-source-parsers/jsoncpp.git

cd ~/jsoncpp/jsoncpp

mkdir -p ~/jsoncpp/jsoncpp/build/debug

cd ~/jsoncpp/jsoncpp/build/debug
cmake -DCMAKE_BUILD_TYPE=debug -DJSONCPP_LIB_BUILD_SHARED=OFF -G "Unix Makefiles" ../../
make
make install