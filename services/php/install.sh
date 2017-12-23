#!/bin/ash
if [ ! -f .env ]; then
    echo ".env not detected. Setting up environment."
    echo "Waiting 15 seconds for MariaDB to be ready."
    sleep 15
    cp .env.example .env
    printf "\n\nREDIS_HOST=redis\n\nTRUSTED_PROXIES=*" >> .env
    php artisan key:generate --force
    php artisan pterodactyl:env --dbhost=db --dbport=3306 --dbname=pterodactyl --dbuser=pterodactyl \
        --dbpass=pterodactyl --url="$panel_url" --timezone="$timezone" --driver=redis --session-driver=database --queue-driver=database
    case "$email_driver" in
        mail)
            php artisan pterodactyl:mail --driver="$email_driver" --email="$panel_email" --from-name="$email_name"
            ;;
        mandrill)
            php artisan pterodactyl:mail --driver="$email_driver" --email="$panel_email" --username="$email_user" --from-name="$email_name"
            ;;
        postmark)
            php artisan pterodactyl:mail --driver="$email_driver" --email="$panel_email" --username="$email_user" --from-name="$email_name"
            ;;
        mailgun)
            php artisan pterodactyl:mail --driver="$email_driver" --email="$panel_email" --username="$email_user" --host="$email_domain" --from-name="$email_name"
            ;;
        smtp)
            php artisan pterodactyl:mail --driver="$email_driver" --email="$panel_email" --username="$email_user" --password="$email_pass" --host="$email_domain" --port="$email_port" --from-name="$email_name"
            ;;
    esac
    php artisan migrate --force
    php artisan db:seed --force
    php artisan pterodactyl:user --email="$admin_email" --password="$admin_pass" \
        --admin=1 --firstname="$admin_first" --lastname="$admin_last" --username="$admin_username"
    echo "Setup complete."
else
    echo ".env detected. Stopping install script."
    echo "Waiting 5 seconds for supervisord."
    sleep 5
fi
