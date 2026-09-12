#!/bin/sh

FTP_PASS=$(grep -m1 "^FTP_PASS=" /run/secrets/credentials | cut -d= -f2-)

id "$FTP_USER" > /dev/null 2>&1 || adduser -D "$FTP_USER"
echo "$FTP_USER:$FTP_PASS" | chpasswd > /dev/null 2>&1
chown -R "$FTP_USER:$FTP_USER" /var/www/html
grep -qx "$FTP_USER" /etc/vsftpd.userlist 2> /dev/null || echo "$FTP_USER" >> /etc/vsftpd.userlist

exec vsftpd /etc/vsftpd/vsftpd.conf
