FROM alpine:3.23

ARG ADMINER="https://github.com/vrana/adminer/releases/download/v6.0.2/adminer-6.0.2-mysql.php"

WORKDIR /var/www/html/adminer

RUN apk add --no-cache php php-session php-mysqli && wget $ADMINER -O ./index.php

CMD ["php", "-S", "adminer:4242"]