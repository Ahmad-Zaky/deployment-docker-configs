#!/bin/bash

appDir=/var/www/html

# Check application folder exists
if [ ! -d $appDir ]
  then
  echo -e "\n\e[1;31m ERROR: Application folder does not exists \033[0m"
  exit 0
fi

# Change to the project directory
cd $appDir

# Turn on maintenance mode
php artisan down || true

# Pull the latest changes from the git repository
git checkout dev
git pull origin dev

# Install/update composer dependecies
php composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev

# Clear caches you can use optimize instead if your laravel version is 7+
# php artisan cache:clear

# Clear routes you can use optimize instead if your laravel version is 7+
# php artisan route:clear

# Clear views you can use optimize instead if your laravel version is 7+
# php artisan view:clear

# Clear and Cache Config you can use optimize instead if your laravel version is 7+
# php artisan config:cache

# Clear the old boostrap/cache/compiled.php
php artisan clear-compiled

# Recreate boostrap/cache/compiled.php which is accessable in laravel 7+
php artisan optimize

# Run database migrations
php artisan migrate --force

# Restart Queue Workder if using systemctl to monitor the queue listner
# systemctl --user restart queue-worker

# Restart Queue Workder if using supervisorctl to monitor the queue listner
sudo supervisorctl restart laravel-queue:*

# Turn off maintenance mode
php artisan up
