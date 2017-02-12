FROM fedora:latest

MAINTAINER "Jess Smith" jess@terainsights.com

## Install dependencies and useful tools.
RUN dnf -y -v groupinstall "C Development Tools and Libraries" \
	&& dnf -y -v install bc wget clang git java \
		php-cli php-pdo php-pecl-xdebug \
		jsoncpp jsoncpp-devel \
		sqlite sqlite-devel \
		websocketpp-devel \
		openssl openssl-devel \
		coin-or-lemon coin-or-lemon-devel \ 
		oniguruma oniguruma-devel \
		boost boost-devel boost-system \
		astyle \
		R \
		armadillo-devel \
		emacs htop

RUN yum install -y autoconf \
    automake \
    subversion

## Enable PHP short tags. They are frequently used in the Grokit source.
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php.ini

## Install grokit source
RUN cd ~ \
	&& git clone https://github.com/tera-insights/grokit.git

## Install Antlr3 and Antlr3 C Runtime from source
COPY antlr_install.sh /root/antlr_install.sh
RUN cd /root && bash antlr_install.sh

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