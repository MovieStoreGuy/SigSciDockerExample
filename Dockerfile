# Dockerfile example for ubuntu Signal Sciences agent container
FROM ubuntu:xenial

LABEL Maintainer="Signal Sciences Corp." \
      Version="1.0.0"

ENV DEBIAN_FRONTEND=noninteractive       \
    APACHE_RUN_USER=www-data             \
    APACHE_RUN_GROUP=www-data            \
    APACHE_PID_FILE=/var/run/apache2.pid \
    APACHE_RUN_DIR=/var/run/apache2      \
    APACHE_LOCK_DIR=/var/lock/apache2    \
    APACHE_LOG_DIR=/var/log/apache2      \
    LANG=C

RUN  apt-get update && \
     apt-get install -y --no-install-recommends apt-transport-https curl ca-certificates && \
     curl -slL https://apt.signalsciences.net/gpg.key | apt-key add - && \
     echo "deb https://apt.signalsciences.net/release/ubuntu/ xenial main" \
        > /etc/apt/sources.list.d/sigsci-release.list && \
     apt-get update && \
     apt-get install -y --no-install-recommends sigsci-agent sigsci-module-apache apache2 && \
     apt-get remove -y apt-transport-https curl &&\
     apt-get clean && \
     rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* && \
     /usr/sbin/a2enmod signalsciences && \
     mkdir /var/lock/apache2

COPY contrib/index.html /var/www/html/index.html
COPY contrib/signalsciences.png /var/www/html/signalsciences.png

WORKDIR /app
COPY ./start.sh .

ENTRYPOINT ["./start.sh"]
