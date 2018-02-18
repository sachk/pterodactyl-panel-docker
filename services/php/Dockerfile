# https://duckduckgo.com/?q=Parameter+must+be+an+array+or+an+object+that+implements+Countable&t=canonical&ia=web
FROM php:7.2-fpm-alpine

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

# Set up the server working directory.
RUN mkdir -p /var/www/html/pterodactyl
WORKDIR /var/www/html/pterodactyl
RUN chown -R www-data:www-data /var/www/html/pterodactyl

# Deploy panel files.
USER www-data:www-data
RUN curl -Lo panel.tar.gz https://github.com/Pterodactyl/Panel/releases/download/v0.7.0/panel.tar.gz
RUN tar --strip-components=1 -xzvf panel.tar.gz
RUN cp .env.example .env
RUN composer install --no-dev
COPY install.sh /var/www/html/pterodactyl/install
RUN chmod -R 755 storage/* bootstrap/cache

# Copy the remaining configuration files.
USER root:root
RUN mkdir -p /var/log/pterodactyl
COPY schedule /var/spoon/cron/crontabs/schedule
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
