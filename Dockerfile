FROM fedora:latest

MAINTAINER "Jess Smith" jess@terainsights.com

## Install dependencies
RUN echo "Installing depdendencies" \ 
	&& dnf -y -v groupinstall "C Development Tools and Libraries" \
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
		astyle

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