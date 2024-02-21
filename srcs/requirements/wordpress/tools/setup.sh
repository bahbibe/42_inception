#!/bin/sh

sed -i "s/listen = 127.0.0.1:9000/listen = wordpress:9000/" /etc/php81/php-fpm.d/www.conf
if [ ! -f $PWD/wp-config.php ]; then
	wp core download
	wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=mariadb --extra-php << EOF
define( 'WP_REDIS_HOST', 'redis' );
EOF
	wp core install --url=$WP_URL --title=inception --admin_user=$WP_ADMIN --admin_password=$WP_PASS --admin_email=$WP_EMAIL --skip-email
	wp user create --role=author $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASS
	wp plugin install redis-cache --activate
	wp redis enable
fi
php-fpm81 --nodaemonize