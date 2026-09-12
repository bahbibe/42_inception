FROM alpine:3.23

ARG WP_CLI="https://github.com/wp-cli/wp-cli/releases/download/v2.12.0/wp-cli-2.12.0.phar"
ENV WP_CLI_ALLOW_ROOT=1

RUN apk add --no-cache php84 php84-fpm \
	php84-mysqli php84-phar \
	php84-mbstring php84-pdo \
	php84-iconv \
	php84-openssl php84-opcache \
	php84-gettext php84-zip \
	php84-ctype php84-tokenizer && \
	wget $WP_CLI -O /usr/local/bin/wp && chmod +x /usr/local/bin/wp && \
	printf "memory_limit = 512M\nupload_max_filesize = 32M\npost_max_size = 32M\n" > /etc/php84/conf.d/99-inception.ini

COPY ./tools/setup.sh /setup.sh

WORKDIR /var/www/html/wordpress

CMD ["/setup.sh"]
