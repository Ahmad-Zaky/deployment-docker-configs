FROM php:8.1.1-apache

RUN apt-get update -y \
  && apt-get install -y supervisor \
  && mkdir -p /etc/supervisor/conf.d

RUN mkdir -p "/etc/supervisor/logs"

RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-enable mysqli pdo pdo_mysql
RUN apt-get install -y zip libzip-dev \
  && docker-php-ext-configure zip \
  && docker-php-ext-install zip

# COPY ssl/private-selfsigned.key /etc/ssl/private/private-selfsigned.key
# COPY ssl/certs-selfsigned.crt /etc/ssl/certs/certs-selfsigned.crt

# COPY .docker/apache/vhost.conf /etc/apache2/sites-available/000-default.conf
# COPY .docker/apache/ssl.conf /etc/apache2/sites-available/default-ssl.conf
# COPY .docker/apache/ssl-params.conf /etc/apache2/conf-available/ssl-params.conf

# RUN a2enmod ssl
# RUN a2enmod socache_shmcb
# RUN a2enmod headers
# RUN a2enconf ssl-params
# RUN a2ensite default-ssl

COPY .docker/supervisor/conf.d/supervisor-services.conf /etc/supervisor/supervisor-services.conf
COPY .docker/supervisor/conf.d/supervisor-services.conf /etc/supervisor-services.conf
RUN echo "alias super='/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisor-services.conf'" >> ~/.bashrc

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/supervisor-services.conf"]