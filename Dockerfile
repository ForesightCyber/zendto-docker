FROM debian:bullseye
MAINTAINER <lukas@foresightcyber.com>

ARG TIMEZONE=UTC
ENV TIMEZONE=${TIMEZONE}
ARG MAX_POST_SIZE=2G
ENV MAX_POST_SIZE=${MAX_POST_SIZE}

# Install packages
RUN apt update
RUN apt -y install gnupg wget php-cli libapache2-mod-php locales php-sqlite3 php-curl php-mbstring
RUN wget -O - https://zend.to/files/zendto.gpg.asc | apt-key add -
RUN wget https://zend.to/files/zendto-repo.deb
RUN wget https://zend.to/files/zendto_6.11-2.deb
RUN dpkg -i zendto-repo.deb
RUN dpkg -i zendto_6.11-2.deb || true
RUN apt -y install -f
RUN apt update
RUN apt -y install zendto
RUN a2enmod rewrite
RUN mkdir /opt/zendto/config.orig
RUN cp -R /opt/zendto/config/* /opt/zendto/config.orig
RUN mkdir /opt/zendto/templates.orig
RUN cp -R /opt/zendto/templates/* /opt/zendto/templates.orig
COPY apache.conf /etc/apache2/sites-enabled/000-default.conf
COPY run.sh /
COPY zendto.ini /etc/php/7.4/apache2/conf.d/30-zendto.ini

ENTRYPOINT [ "/run.sh" ]
CMD ["run"]

EXPOSE 80
