FROM php:8.1.1-apache
WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html && a2enmod rewrite

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
  && docker-php-ext-install exif && docker-php-ext-enable exif

RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN docker-php-ext-enable mysqli pdo pdo_mysql
RUN apt-get update && apt-get install -y curl zip unzip

COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

RUN touch /usr/local/etc/php/conf.d/uploads.ini \
    && echo "upload_max_filesize = 2024M" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "post_max_size = 2024M" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "memory_limit = 2024M" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "max_execution_time = 30000" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "max_input_time = 30000" >> /usr/local/etc/php/conf.d/uploads.ini
RUN echo "max_file_uploads = 1000" >> /usr/local/etc/php/conf.d/uploads.ini

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

# work around to fix Permission Denied issue as we create root files
RUN echo "mmodel() {\n"\
  "php artisan make:model \$1\n"\
  "chp\n"\
"}\n"\
>> ~/.bashrc

RUN echo "mmodelfull() {\n"\
  "php artisan make:model \$1 -mcrf\n"\
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


