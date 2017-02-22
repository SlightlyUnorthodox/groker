#!/bin/sh

mkdir -p ~/mct
cd ~/mct

# Remove onig if exists
[ -e ~/mct/libmct1.6 ] && rm -r ~/mct/libmct1.6
[ -e ~/mct/1.6 ] && rm -r ~/mct/1.6

# Download ANTLR Parser Generator version 3.4
bzr branch lp:libmct/1.6
mv 1.6 libmct1.6

# Make MCT library
cd ~/mct/libmct1.6
make install