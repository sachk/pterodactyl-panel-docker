#!/bin/ash
if [ ! -f .env ]; then
    echo ".env not detected. Setting up environment."
    echo "Waiting 15 seconds for MariaDB to be ready."
    sleep 15
    cp .env.example .env
    printf "\n\nREDIS_HOST=redis\n\nTRUSTED_PROXIES=*" >> .env
    php artisan key:generate --force
    php artisan p:environment:setup --author="$author" --url="$url" --timezone="$timezone" \
        --cache=redis --session=redis --queue=redis --redis-host=redis --redis-pass="" --redis-port="6379" --disable-settings-ui
    php artisan p:environment:database --host=db --port=3306 --database=pterodactyl \
        --username=pterodactyl --password=pterodactyl
    case "$driver" in
        mail)
            php artisan p:environment:mail --driver="$driver" --email="$panel_email" --from="$from" \
                --encryption="$encryption"
            ;;
        mandrill)
            php artisan p:environment:mail --driver="$driver" --email="$panel_email" --from="$from" \
                --encryption="$encryption" --password="$email_password"
            ;;
        postmark)
            php artisan p:environment:mail --driver="$driver" --email="$panel_email" --from="$from" \
                --encryption="$encryption" --username="$email_username"
            ;;
        mailgun)
            php artisan p:environment:mail --driver="$driver" --email="$panel_email" --from="$from" \
                --encryption="$encryption" --host="$host" --password="$email_password"
            ;;
        smtp)
            php artisan p:environment:mail --driver="$driver" --email="$panel_email" --from="$from" \
                --encryption="$encryption" --host="$host" --port="$port" --username="$email_username" \
                --password="$email_password"
            ;;
    esac
    php artisan migrate --force
    php artisan db:seed --force
    php artisan p:user:make --email="$admin_email" --username="$admin_username" \
        --name-first="$admin_first" --name-last="$admin_last" --password="$admin_password" \
        --admin=1
    echo "Setup complete."
else
    echo ".env detected. Stopping install script."
    echo "Waiting 5 seconds for supervisord."
    sleep 5
fi
