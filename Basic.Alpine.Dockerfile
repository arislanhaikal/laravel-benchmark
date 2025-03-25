FROM alpine:3.21

# Run as root
USER root

# Setup document root
WORKDIR /var/www/html

# Install packages and remove default server definition
RUN apk add --no-cache \
    curl \
    nginx \
    php84 \
    php84-bcmath \
    php84-ctype \
    php84-cli \
    php84-curl \
    php84-dom \
    php84-fpm \
    php84-gd \
    php84-intl \
    php84-iconv \
    php84-json \
    php84-mbstring \
    php84-mysqli \
    php84-opcache \
    php84-openssl \
    php84-phar \
    php84-session \
    php84-tokenizer \
    php84-xml \
    php84-xmlwriter \
    php84-xmlreader \
    php84-simplexml \
    php84-zip \
    php84-sodium \
    php84-pcntl \
    php84-fileinfo \
    php84-posix \
    php84-pdo_mysql \
    php84-pdo_sqlite \
    php84-pecl-memcached \
    php84-pecl-redis \
    busybox-suid \
    supervisor \
    vim \
    dcron \
    libcap \
    sqlite \
    bash \
    tzdata

# Set timezone
ENV TZ=Asia/Jakarta

# Install Composer
RUN /usr/bin/php84 -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && /usr/bin/php84 composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && /usr/bin/php84 -r "unlink('composer-setup.php');"

RUN ln -s /usr/bin/php84 /usr/bin/php

# Configure nginx - http
COPY deployment/nginx/nginx.conf /etc/nginx/nginx.conf

# Configure nginx - default server
COPY deployment/nginx/default.conf /etc/nginx/conf.d/default.conf

# Configure PHP-FPM
COPY deployment/nginx/fpm-pool.conf /etc/php84/php-fpm.d/www.conf
COPY deployment/php.ini /etc/php84/conf.d/custom.ini

# Configure supervisord
COPY deployment/nginx/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Set crond as user
RUN chown nobody:nobody /usr/sbin/crond /usr/bin/crontab \
    && setcap cap_setgid=ep /usr/sbin/crond \
    && setcap cap_setgid=ep /usr/bin/crontab

# Add application
COPY --chown=nobody  . . 

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody:nobody /var/www/html /run /var/lib/nginx /var/log/nginx

# Set cronjob
RUN crontab /var/www/html/deployment/nginx/crontabs/nobody

# Switch to use a non-root user from here on
USER nobody

# run composer install to install the dependencies
RUN composer install \
    --optimize-autoloader \
    --no-dev \
    --no-interaction \
    --no-progress

# Expose the port nginx is reachable on
EXPOSE 80 8000

# Let supervisord start nginx & php-fpm
CMD ["/bin/sh", "-c", "/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf & php artisan serve --host 0.0.0.0 --port 8000"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping
