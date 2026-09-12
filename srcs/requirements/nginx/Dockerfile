FROM alpine:3.23

RUN apk add --no-cache nginx openssl gettext

COPY ./conf/conf.template /conf.template
COPY ./tools/setup.sh /setup.sh

CMD ["/setup.sh"]
