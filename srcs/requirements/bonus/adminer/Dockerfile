FROM alpine:3.18

ARG ADMINER="https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php"
ARG THEME="https://raw.githubusercontent.com/pepa-linha/Adminer-Design-Dark/master/adminer.css"

WORKDIR /var/www/html/adminer

RUN apk update && apk add --no-cache php php-session php-mysqli &&  wget $ADMINER -O ./index.php  && wget $THEME -O ./adminer.css

CMD ["php", "-S", "adminer:4242"]