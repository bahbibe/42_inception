FROM alpine:3.18

RUN apk update  && apk add --no-cache php 

COPY ./src/ /var/www/html/website

WORKDIR /var/www/html/website

CMD [ "php", "-S", "website:1337"]

