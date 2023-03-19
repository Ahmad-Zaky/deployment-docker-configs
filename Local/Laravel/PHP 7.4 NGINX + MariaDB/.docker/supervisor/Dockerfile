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

COPY .docker/supervisor/conf.d/queue-worker.conf /etc/supervisor/queue-worker.conf
COPY .docker/supervisor/conf.d/queue-worker.conf /etc/queue-worker.conf
RUN echo "alias super='/usr/bin/supervisord -c /etc/supervisor/conf.d/queue-worker.conf'" >> ~/.bashrc

CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisor/queue-worker.conf"]