#!/bin/sh

adduser -D $FTP_USER
echo "$FTP_USER:$FTP_PASS" | chpasswd &> /dev/null
chown -R $FTP_USER:$FTP_USER /var/www/html
echo $FTP_USER | tee -a /etc/vsftpd.userlist &> /dev/null

vsftpd /etc/vsftpd/vsftpd.conf