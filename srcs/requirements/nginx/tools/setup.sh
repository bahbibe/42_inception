#!/bin/sh
set -e

# self-signed cert, made at start so it is not baked into the image
if [ ! -f "$CERT_PATH" ]; then
	mkdir -p "$(dirname "$CERT_PATH")" "$(dirname "$KEY_PATH")"
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-out "$CERT_PATH" -keyout "$KEY_PATH" \
		-subj "/C=MA/L=Oujda/O=42/OU=inception/CN=$WP_URL"
	chmod 600 "$KEY_PATH"
fi

envsubst '${CERT_PATH} ${KEY_PATH} ${WP_URL}' < /conf.template > /etc/nginx/http.d/nginx.conf

exec nginx -g "daemon off;"
