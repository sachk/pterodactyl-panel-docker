FROM php:7.2-fpm-alpine

ENV PANEL_VERSION=v0.7.7

# Set up all the dependencies for the PHP container.
RUN apk add --no-cache curl git supervisor tar unzip
RUN docker-php-ext-install bcmath
# https://github.com/docker-library/php/issues/483
# RUN docker-php-ext-install curl
# https://stackoverflow.com/questions/39657058/installing-gd-in-docker#39658592
RUN apk add --no-cache libpng-dev
RUN docker-php-ext-install gd
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install tokenizer
# https://lists.alpinelinux.org/alpine-aports/2526.html
RUN apk add --no-cache libxml2-dev
RUN docker-php-ext-install xml
RUN docker-php-ext-install zip
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set up the server working directories.
RUN adduser -g '' -D -u 9999 pterodactyl
RUN mkdir -p /var/www/html/env
RUN mkdir -p /var/www/html/pterodactyl
WORKDIR /var/www/html/pterodactyl
RUN chown -R pterodactyl:pterodactyl /var/www/html/pterodactyl /var/www/html/env

# Deploy panel files.
USER pterodactyl:pterodactyl
RUN curl -Lo panel.tar.gz https://github.com/Pterodactyl/Panel/releases/download/${PANEL_VERSION}/panel.tar.gz
RUN tar --strip-components=1 -xzvf panel.tar.gz
# Since Docker's configuration mounting feature sucks, we're going to use a cheap
# workaround involving symbolic links.
RUN cp .env.example /var/www/html/env/.env
RUN ln -s /var/www/html/env/.env /var/www/html/pterodactyl/.env
RUN composer install --no-dev
RUN chmod -R 755 storage/* bootstrap/cache

# Copy the remaining configuration files.
USER root:root
RUN mkdir -p /var/log/pterodactyl
COPY install.sh /usr/local/bin/install
RUN chmod +x /usr/local/bin/install
COPY upgrade.sh /usr/local/bin/upgrade
RUN chmod +x /usr/local/bin/upgrade
COPY schedule /var/spoon/cron/crontabs/schedule
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
