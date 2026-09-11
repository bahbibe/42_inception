FROM alpine:3.23

ARG WP_CLI="https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar"
ENV WP_CLI_ALLOW_ROOT=1

RUN apk update && \
	apk add --no-cache php84 php84-fpm \
	php84-mysqli php84-phar \
	php84-mbstring php84-pdo \
	php84-iconv \
	php84-openssl php84-opcache \
	php84-gettext php84-zip \
	php84-ctype php84-tokenizer \
	wget mariadb-client && \
	wget $WP_CLI -O /usr/local/bin/wp && chmod +x /usr/local/bin/wp && \
	echo "memory_limit = 512M" > /etc/php84/conf.d/99-inception.ini

COPY ./tools/setup.sh /setup.sh

WORKDIR /var/www/html/wordpress

CMD ["/setup.sh"]
