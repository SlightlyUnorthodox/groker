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
		antlr3-C-devel antlr3-C \
		coin-or-lemon coin-or-lemon-devel \ 
		oniguruma oniguruma-devel \
		boost boost-devel boost-system \
		astyle \
		R \
		armadillo-devel \
		emacs htop

## Enable PHP short tags. They are frequently used in the Grokit source.
RUN sed -i 's/short_open_tag = Off/short_open_tag = On/g' /etc/php.ini

## Install grokit source
RUN cd ~ \
	&& git clone https://github.com/tera-insights/grokit.git

## Hack to get antlr3.4 to run
COPY antlr3 /root/antlr3
RUN cd /root && wget \
	https://github.com/antlr/website-antlr3/raw/gh-pages/download/antlr-3.4-complete.jar \
	&& sed -i 's,ANTLR=antlr3,ANTLR="/root/antlr3",g' ~/grokit/src/parserMake.sh

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