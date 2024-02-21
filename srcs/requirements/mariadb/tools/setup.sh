#!/bin/sh
if [ ! -d "/var/lib/mysql/mysql" ]; then
    rc-service mariadb setup
    rc-service mariadb start
    mariadb-secure-installation <<EOF
$DB_ROOT_PASS
n
n
Y
Y
Y
Y
EOF
    rc-service mariadb restart
    rc-update add mariadb default
    mariadb -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;" 
    mariadb -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';" 
    mariadb -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
    mariadb -e "FLUSH PRIVILEGES;"
    rc-service mariadb stop
fi
sed -i "s|.*skip-networking.*|#skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
mariadbd-safe

