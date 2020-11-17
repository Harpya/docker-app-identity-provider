#!/bin/sh

echo "--> Running missing migrations"
cd /var/www/html

# small delay to ensure the DB is up and running...
sleep 5

# Perform migration
vendor/bin/phinx migrate

echo "--> Starting up Harpya Identity Provider"
/usr/local/bin/docker-php-entrypoint php-fpm