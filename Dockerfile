FROM alpine:latest

# Create user
RUN adduser -D -u 1000 -g 1000 -s /bin/sh www-data && \
    mkdir -p /www && \
    chown -R www-data:www-data /www

# Install tini - 'cause zombies - see: https://github.com/ochinchina/supervisord/issues/60
# (also pkill hack)
RUN apk add --no-cache --update tini

# Install a golang port of supervisord
COPY --from=ochinchina/supervisord:latest /usr/local/bin/supervisord /usr/bin/supervisord

# Install nginx & gettext (envsubst)
# Create cachedir and fix permissions
RUN apk add --no-cache --update \
    gettext \
    nginx && \
    mkdir -p /var/cache/nginx && \
    mkdir -p /var/tmp/nginx && \
    chown -R www-data:www-data /var/cache/nginx && \
    chown -R www-data:www-data /var/lib/nginx && \
    chown -R www-data:www-data /var/tmp/nginx

# Install PHP/FPM + Modules
RUN apk add --no-cache --update \
    php7 \
    php7-gd \
    php7-openssl \
    php7-pcntl \
    php7-pdo \
    php7-pdo_mysql \
    git

# Runtime env vars are envstub'd into config during entrypoint
ENV SERVER_NAME="localhost"
ENV SERVER_ALIAS=""
ENV SERVER_ROOT=/www

# Alias defaults to empty, example usage:
# SERVER_ALIAS='www.example.com'

COPY ./supervisord.conf /supervisord.conf
COPY ./php-fpm-www.conf /etc/php7/php-fpm.d/www.conf
COPY ./nginx.conf.template /nginx.conf.template
COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN git clone https://github.com/jordansamuel/PASTE /www

RUN chmod +x /docker-entrypoint.sh && chmod -R 777 /www/u && chmod -R 777 /www



# Nginx on :80
EXPOSE 80
WORKDIR /www
ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]