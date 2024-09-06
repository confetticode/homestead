#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

add-apt-repository -y ppa:ondrej/php

apt-get update

apt-get install -y software-properties-common curl git unzip zip supervisor nginx \
  php8.3-cli \
  php8.3-curl \
  php8.3-fpm \
  php8.3-gd \
  php8.3-gmp \
  php8.3-imap \
  php8.3-intl \
  php8.3-mbstring \
  php8.3-mcrypt \
  php8.3-mysql \
  php8.3-pgsql \
  php8.3-sqlite3 \
  php8.3-xml \
  php8.3-zip \
  php-memcached

sed -i "s/www-data/vagrant/g" /etc/nginx/nginx.conf;

php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer

sed -i "s/www-data/vagrant/g" "/etc/php/8.3/fpm/pool.d/www.conf";

systemctl restart nginx
systemctl restart php8.3-fpm

MYSQL_ROOT_PASSWORD=secret

sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
sudo apt-get -y install mysql-server
