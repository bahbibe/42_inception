#!/bin/sh
set -e

FTP_PASS=$(grep -m1 "^FTP_PASS=" /run/secrets/credentials | cut -d= -f2-)

# same group as php-fpm, so both can write the wordpress files
id "$FTP_USER" > /dev/null 2>&1 || adduser -D -G nogroup "$FTP_USER"
echo "$FTP_USER:$FTP_PASS" | chpasswd > /dev/null 2>&1

# files stay owned by php-fpm, the ftp user writes through the group
chown -R nobody:nogroup /var/www/html/wordpress
chmod -R g+w /var/www/html/wordpress

grep -qx "$FTP_USER" /etc/vsftpd.userlist 2> /dev/null || echo "$FTP_USER" >> /etc/vsftpd.userlist

exec vsftpd /etc/vsftpd/vsftpd.conf
