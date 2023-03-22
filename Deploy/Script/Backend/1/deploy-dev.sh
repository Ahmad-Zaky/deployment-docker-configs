#!/bin/bash

echo -e '\n\e[1m\e[34m Entering into backend directory...\e[0m\n'

cd /var/www/server
#php artisan down || true
echo -e $PWD

echo -e '\n\e[1m\e[34m Bitbucket Credentials...\e[0m\n'

cat ~/password

echo -e '\n\e[1m\e[34m Pulling code from remote...\e[0m\n'
sudo git pull origin dev

echo -e '\n\e[1m\e[34m Running Migrations...\e[0m\n'
sudo  php artisan migrate


#sudo composer dump-autoload
sudo php artisan route:clear; sudo  php artisan view:clear;sudo  php artisan cache:clear;

echo -e '\n\e[1m\e[34m Restarting Supervisor Laravel Queue Worker...\e[0m\n'
sudo supervisorctl restart laravel-queue:*

#php artisan up

echo -e '\n\e[1m\e[34m All done now!\e[0m\n'
echo -e '\n\e[1m\e[34m Thanks for automating this deployment process!\e[0m\n'
