############################################################
# Dockerfile to build PHP7 with copmposer installed
# Based on php7 apache official images
############################################################


FROM php:7-apache

MAINTAINER eqmo

#install all the system dependencies and enable PHP modules 
RUN apt-get update && apt-get install -y \  
      libicu-dev \
      libpq-dev \
      libmcrypt-dev \
      zlib1g-dev \
      mysql-client \
      git \
      zip \
      unzip \
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install \
      intl \
      mbstring \
      pcntl \
      pdo_mysql \
      pdo_pgsql \
      pgsql \
      zip \
      opcache

#install latest composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

#application folder
ENV APP_HOME /var/www/html

#change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

#change the web_root to laravel /var/www/html/public folder
#RUN sed -i -e "s/html/html\/webroot/g" /etc/apache2/sites-enabled/000-default.conf

# enable apache module rewrite
RUN a2enmod rewrite

#copy source files and run composer
COPY . /var/www/html/

#change ownership of our applications
RUN chown -R www-data:www-data $APP_HOME
