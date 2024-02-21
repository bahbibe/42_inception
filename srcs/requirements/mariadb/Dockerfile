FROM alpine:3.18

RUN apk update && apk add --no-cache mariadb mariadb-client openrc && openrc && touch /run/openrc/softlevel

COPY ./tools/setup.sh /setup.sh

CMD ["/setup.sh"]
