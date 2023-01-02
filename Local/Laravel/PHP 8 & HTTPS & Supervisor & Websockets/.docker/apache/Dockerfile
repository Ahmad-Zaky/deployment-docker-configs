FROM php:8.1.1-apache
WORKDIR /var/www/html

RUN apt-get update -y && apt-get install -y sendmail libpng-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libonig-dev \
        && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
        && docker-php-ext-install gd

RUN apt-get install -y git
RUN apt-get install -y zip libzip-dev \
  && docker-php-ext-configure zip \
  && docker-php-ext-install zip \
  && docker-php-ext-install exif && docker-php-ext-enable exif \
  && docker-php-ext-install sockets

RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-enable mysqli pdo pdo_mysql
RUN apt-get update && apt-get install -y curl zip unzip

RUN docker-php-ext-install bcmath opcache

RUN apt-get install -y openssl

RUN mkdir -p "/var/www/html/ssl"

RUN apt-get install -y openssl
RUN openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj \
    "/C=../ST=...../L=..../O=..../CN=..." \
    -keyout /var/www/html/ssl/private-selfsigned.key -out /var/www/html/ssl/certs-selfsigned.crt

COPY ssl/private-selfsigned.key /etc/ssl/private/private-selfsigned.key
COPY ssl/certs-selfsigned.crt /etc/ssl/certs/certs-selfsigned.crt

COPY .docker/apache/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY .docker/apache/ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY .docker/apache/ssl-params.conf /etc/apache2/conf-available/ssl-params.conf

RUN a2enmod ssl
RUN a2enmod socache_shmcb
RUN a2enmod headers
RUN a2enconf ssl-params
RUN a2ensite default-ssl
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_wstunnel

RUN touch /usr/local/etc/php/conf.d/uploads.ini
RUN echo "upload_max_filesize = 2024M" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "post_max_size = 2024M" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "memory_limit = 2024M" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "max_execution_time = 30000" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "max_input_time = 30000" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "max_file_uploads = 1000" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "zend_extension=opcache.so" >> /usr/local/etc/php/conf.d/uploads.ini

RUN echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "opcache.enable_cli=0" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "opcache.validate_timestamp=1" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "opcache.interned_strings_buffer=64" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "opcache.max_accelerated_files=32531" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "opcache.save_comments=1" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "opcache.revalidate_freq=1" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/uploads.ini

RUN chown -R www-data:www-data /var/www/html && a2enmod rewrite

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer


##################
# Custom Aliases #
##################

# Small hack for me to simplify chmod command needed on adding new files from within the container
# to prevent Permission Denied Issues
RUN echo "alias chp='chmod -R 0777 app/ database/ storage/ config/ resources/'" >> ~/.bashrc
RUN echo "alias optimize='php artisan optimize'" >> ~/.bashrc
RUN echo "alias migrate='php artisan migrate'" >> ~/.bashrc
RUN echo "alias smigrate='php artisan migrate --seed'" >> ~/.bashrc
RUN echo "alias seed='php artisan db:seed'" >> ~/.bashrc
RUN echo "alias tinker='php artisan tinker'" >> ~/.bashrc
RUN echo "alias art='php artisan'" >> ~/.bashrc
RUN echo "alias autoload='composer dumpautoload --ignore-platform-reqs'" >> ~/.bashrc

# work around to fix Permission Denied issue as we create root files
RUN echo "mmodel() {\n"\
  "php artisan make:model \$1 \$2\n"\
  "chp\n"\
"}\n"\
>> ~/.bashrc

RUN echo "mmodelfull() {\n"\
  "php artisan make:model \$1 -mcrf\n"\
  "chp\n"\
"}\n"\
>> ~/.bashrc

RUN echo "mmigration() {\n"\
  "php artisan make:migration \$1\n"\
  "chp\n"\
"}\n"\
>> ~/.bashrc

RUN echo "mrcontroller() {\n"\
  "php artisan make:controller \$1 --resource\n"\
  "chp\n"\
"}\n"\
>> ~/.bashrc

RUN echo "mresource() {\n"\
  "php artisan make:resource \$1\n"\
  "chp\n"\
"}\n"\
>> ~/.bashrc

RUN echo "mcresource() {\n"\
  "php artisan make:resource \$1 --collection\n"\
  "chp\n"\
"}\n"\
>> ~/.bashrc

RUN echo "mseeder() {\n"\
  "php artisan make:seeder \$1\n"\
  "chp\n"\
"}\n"\
>> ~/.bashrc

RUN echo "mfactory() {\n"\
  "php artisan make:factory \$1\n"\
  "chp\n"\
"}\n"\
>> ~/.bashrc


