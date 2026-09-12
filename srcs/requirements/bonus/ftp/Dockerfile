FROM alpine:3.23

RUN apk add --no-cache vsftpd

COPY ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY ./tools/setup.sh /setup.sh

WORKDIR /var/www/html

CMD ["/setup.sh"]
