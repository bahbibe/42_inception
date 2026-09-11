#!/bin/sh
set -e

# double single quotes so values are safe inside SQL string literals
esc() { printf '%s' "$1" | sed "s/'/''/g"; }

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null
    mariadbd --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$(esc "$DB_ROOT_PASS")';
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$(esc "$DB_USER")'@'%' IDENTIFIED BY '$(esc "$DB_PASS")';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$(esc "$DB_USER")'@'%';
FLUSH PRIVILEGES;
EOF
fi
sed -i "s|.*skip-networking.*|#skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
exec mariadbd --user=mysql
