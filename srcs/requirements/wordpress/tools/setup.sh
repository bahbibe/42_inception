#!/bin/sh
set -e
sed -i "s/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/" /etc/php84/php-fpm.d/www.conf

# credentials come from docker secrets, not from the environment
read_cred() { grep -m1 "^$1=" /run/secrets/credentials | cut -d= -f2-; }
DB_PASS=$(cat /run/secrets/db_password)
WP_PASS=$(read_cred WP_PASS)
WP_USER_PASS=$(read_cred WP_USER_PASS)

# the subject forbids admin/administrator in the administrator name
case "$(echo "$WP_ADMIN" | tr 'A-Z' 'a-z')" in
	*admin*) echo "WP_ADMIN must not contain 'admin'" >&2; exit 1 ;;
esac

# depends_on only orders start, wait until mariadb accepts connections.
# the check uses php-mysqli, already in the image, so no mariadb client is
# needed and no failed TLS handshake is counted against max_connect_errors.
tries=0
until php -r 'exit(@mysqli_connect("mariadb", $argv[1], $argv[2]) ? 0 : 1);' "$DB_USER" "$DB_PASS" > /dev/null 2>&1; do
	tries=$((tries + 1))
	if [ "$tries" -ge 60 ]; then
		echo "mariadb did not answer after 60 tries, check DB_USER and the db_password secret" >&2
		exit 1
	fi
	sleep 1
done

if [ ! -f "$PWD/wp-config.php" ]; then
	wp core download --force
	wp config create --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS" --dbhost=mariadb --extra-php << EOF
define( 'WP_REDIS_HOST', '$WP_REDIS_HOST' );
EOF
	wp core install --url="https://$WP_URL" --title=inception --admin_user="$WP_ADMIN" --admin_password="$WP_PASS" --admin_email="$WP_EMAIL" --skip-email
	wp user create --role=author "$WP_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASS"
	wp plugin install redis-cache --activate
	wp redis enable
fi
# written on every start, so an existing install gets it too
mkdir -p wp-content/mu-plugins
cat > wp-content/mu-plugins/mailpit.php <<'PHP'
<?php
// send all wordpress mail to the mailpit container
add_action( 'phpmailer_init', function ( $mailer ) {
	$mailer->isSMTP();
	$mailer->Host = 'mailpit';
	$mailer->Port = 1025;
	$mailer->SMTPAuth = false;
	$mailer->SMTPAutoTLS = false;
} );
PHP

chown -R nobody:nogroup /var/www
chmod -R g+w /var/www/html/wordpress
exec php-fpm84 --nodaemonize
