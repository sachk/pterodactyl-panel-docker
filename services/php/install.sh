#!/bin/ash

##
# This is an install script to quickly set up Pterodactyl Panel. Do NOT use on an
# already configured environment, or things can go horribly wrong!
##
if [ "$(whoami)" != "pterodactyl" ]; then
    echo "Rerunning script as webserver user."
    exec su -c /usr/local/bin/install pterodactyl
fi

echo "Are you sure you want to continue the install script? (Y/n)"
read -n1 run

if [ "$run" = "y" ] || [ "$run" = "Y" ]; then
    echo "Running install script."
    echo "Waiting 15 seconds for MariaDB to be ready."
    sleep 15

    echo "Adding additional parameters to .env file."
    printf "\n\nTRUSTED_PROXIES=*" >> .env
    php artisan key:generate --force

    echo "Running configuration scripts."
    php artisan p:environment:setup --cache=redis --session=redis --queue=redis \
        --redis-host=redis --redis-pass="" --redis-port=6379
    php artisan p:environment:database --host=db --port=3306 --database=pterodactyl \
        --username=pterodactyl --password=pterodactyl
    php artisan p:environment:mail

    echo "Running migrations."
    php artisan migrate --force
    php artisan db:seed --force

    echo "Running user creation script."
    php artisan p:user:make --admin=1

    echo "Setup complete. Please restart the container to load changes."
else
    echo "Exiting."
fi
