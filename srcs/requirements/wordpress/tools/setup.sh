#!/bin/sh
set -e
sed -i "s/listen = 127.0.0.1:9000/listen = wordpress:9000/" /etc/php84/php-fpm.d/www.conf

# credentials come from docker secrets, not from the environment
read_cred() { grep -m1 "^$1=" /run/secrets/credentials | cut -d= -f2-; }
DB_PASS=$(cat /run/secrets/db_password)
WP_PASS=$(read_cred WP_PASS)
WP_USER_PASS=$(read_cred WP_USER_PASS)

# depends_on only orders start, wait until mariadb accepts connections.
# --skip-ssl: the mariadb 11 client tries TLS by default, the server has no cert,
# and every failed handshake counts toward max_connect_errors (host gets blocked).
until mariadb-admin ping -h mariadb --skip-ssl -u"$DB_USER" -p"$DB_PASS" --silent > /dev/null 2>&1; do
	sleep 1
done

if [ ! -f "$PWD/wp-config.php" ]; then
	wp core download --force
	wp config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS" --dbhost=mariadb --extra-php << EOF
define( 'WP_REDIS_HOST', 'redis' );
EOF
	wp core install --url="https://$WP_URL" --title=inception --admin_user="$WP_ADMIN" --admin_password="$WP_PASS" --admin_email="$WP_EMAIL" --skip-email
	wp user create --role=author "$WP_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASS"
	wp plugin install redis-cache --activate
	wp redis enable
fi
chown -R nobody:nogroup /var/www
exec php-fpm84 --nodaemonize
