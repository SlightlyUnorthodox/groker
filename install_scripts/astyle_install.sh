#!/bin/sh

mkdir -p ~/astyle
cd ~/astyle

# Download Astyle 2.06
wget -q https://sourceforge.net/projects/astyle/files/astyle/astyle%202.06/astyle_2.06_linux.tar.gz/download -O astyle.tar.gz
tar xvzf astyle.tar.gz

# Make astyle for gcc
cd ~/astyle/astyle/build/gcc
make release shared static

# Make astyle for clang
cd ~/astyle/astyle/build/clang
make release shared static
