FROM alpine:3.18

ARG WP_CLI="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"

RUN apk update && \
	apk add --no-cache php php-fpm \
	php-mysqli php-phar \
	php-mbstring php-pdo \
	php-iconv \
	php-openssl php-opcache \
	php-gettext php-zip \
	wget mariadb-client && \ 
	wget $WP_CLI -O /usr/local/bin/wp && chmod +x /usr/local/bin/wp

COPY ./tools/setup.sh /setup.sh

WORKDIR /var/www/html/wordpress

CMD ["/setup.sh"]
