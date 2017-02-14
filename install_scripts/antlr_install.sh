#!/bin/sh

mkdir -p ~/antlr
cd ~/antlr

# Download ANTLR Parser Generator version 3.4
wget -q "https://github.com/antlr/website-antlr3/raw/gh-pages/download/antlr-3.4-complete.jar"

# Add ANTLR to CLASSPATH and run it
export CLASSPATH=~/antlr/antlr-3.4-complete.jar:$CLASSPATH

# Add antlr3 as command to usr and sudo path
#sh -c "echo 'java -jar /home/vagrant/prereqs/antlr/antlr-3.4-complete.jar' > /usr/local/bin/antlr3"
sh -c "echo 'java -cp ~/antlr/antlr-3.4-complete.jar org.antlr.Tool \$*' > /usr/local/bin/antlr3"
chmod a+x /usr/local/bin/antlr3

sh -c "echo 'java -cp ~/antlr/antlr-3.4-complete.jar org.antlr.Tool \$*' > /usr/sbin/antlr3"
chmod a+x /usr/sbin/antlr3

# Confirm position
cd ~/antlr

# Download antlr C runtime
svn checkout --force https://github.com/antlr/antlr3/trunk/runtime/C

# Move into C runtime dir
cd ~/antlr/C

# Install C runtime
autoreconf --install
autoconf
./configure --enable-64bit
make
make install
make check

# Establish symlnks for anltlr3c.so
echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr-local.conf

# Rebuild ld cache
rm -f /etc/ld.so.cache
ldconfig
