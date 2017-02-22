FROM centos:7.3.1611

MAINTAINER "Jess Smith" jess@terainsights.com

## Install dependencies and useful tools.
RUN yum -y update && yum clean all

RUN yum install -y epel-release \
	autoconf \
    automake \
    subversion \
    libtool \
    ncurses-libs.i686 \
    bison \
    flex \
    glibc.i686 \
    glibc.devel.i686 \
    bzr \
    gperftools-libs.x86_64 \
    gperftools-devel.x86_64

## WARNING! 'dnf' install fails unless built on its own 'RUN'
RUN yum -y install dnf

RUN dnf -y -v groupinstall "C Development Tools and Libraries" \
	&& dnf -y -v install bc wget clang git java \
		php-cli php-pdo php-pecl-xdebug php-pear \
		jsoncpp jsoncpp-devel \
		sqlite sqlite-devel \
		openssl openssl-devel \
		oniguruma oniguruma-devel \
		boost boost-devel boost-system \
		R \
		armadillo-devel \
		emacs htop \
		libstdc++.so.6

## Enable PHP short tags. They are frequently used in the Grokit source.
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php.ini

## Install grokit source
RUN cd ~ \
	&& git clone https://github.com/tera-insights/grokit.git

## Install Antlr3 and Antlr3 C Runtime from source
COPY install_scripts/antlr_install.sh /root/antlr_install.sh
RUN cd /root && bash antlr_install.sh

## Install Astyle from source
COPY install_scripts/astyle_install.sh /root/astyle_install.sh
RUN cd /root && bash astyle_install.sh

## Install LEMON Graph Library from source
COPY install_scripts/lemon_install.sh /root/lemon_install.sh
RUN cd /root && bash lemon_install.sh

## Install Websocketpp from source
COPY install_scripts/websocketpp_install.sh /root/websocketpp_install.sh
RUN cd /root && bash websocketpp_install.sh

## Compile grokit
RUN cd ~/grokit/src \
	&& ./default.compile.grokit.sh

## Set up disk striping
COPY setup_disk.sh /root/setup_disk.sh
RUN  cd /root && bash setup_disk.sh

## Install grokit executable globally
RUN cd /root/grokit/src && PREFIX=/usr make install

## Install base grokit library
RUN grokit makelib /root/grokit/Libs/base

## Install R statistics library
RUN cd ~ \
	&& git clone https://github.com/tera-insights/statistics.git \
	&& grokit makelib statistics

## Install R tools
COPY installDeps.R /root/installDeps.R
COPY buildJSON.R /root/buildJSON.R

## Install base R library
RUN cd ~ \
	&& Rscript installDeps.R \
	&& Rscript buildJSON.R \ 
	&& git clone https://github.com/tera-insights/gtBase.git \ 
	&& cd gtBase && git checkout add-offline-support \
	&& cd .. \
	&& mode=offline R CMD INSTALL gtBase