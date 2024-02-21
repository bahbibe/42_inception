FROM alpine:3.18

RUN apk update && apk add --no-cache vsftpd

COPY ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY ./tools/setup.sh /setup.sh

WORKDIR /var/www/html

CMD ["/setup.sh"]
