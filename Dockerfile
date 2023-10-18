FROM debian:bookworm
MAINTAINER <lukas@foresightcyber.com>

ARG TIMEZONE=UTC
ENV TIMEZONE=${TIMEZONE}
ARG MAX_POST_SIZE=2G
ENV MAX_POST_SIZE=${MAX_POST_SIZE}

# Install packages
RUN apt update
RUN apt install -y wget
RUN wget -O /etc/apt/trusted.gpg.d/zendto.asc https://zend.to/files/zendto.gpg.asc 
RUN wget https://zend.to/files/zendto-repo.deb
RUN dpkg -i zendto-repo.deb
RUN apt update
RUN apt-get -o Dpkg::Options::="--force-confnew" -y install zendto
RUN apt install -y libapache2-mod-php php8.2-sqlite3 php8.2-curl
RUN a2enmod rewrite
RUN mkdir /opt/zendto/config.orig
RUN cp -R /opt/zendto/config/* /opt/zendto/config.orig
RUN mkdir /opt/zendto/templates.orig
RUN cp -R /opt/zendto/templates/* /opt/zendto/templates.orig
COPY apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY run.sh /
COPY zendto.ini /etc/php/8.2/apache2/conf.d/30-zendto.ini

ENTRYPOINT [ "/run.sh" ]
CMD ["run"]

EXPOSE 80
