FROM alpine:3.23

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY ./tools/setup.sh /setup.sh

CMD ["/setup.sh"]
