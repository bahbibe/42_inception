FROM alpine:3.18

ARG CERT_PATH
ARG KEY_PATH

COPY ./conf/conf.template /conf.template

RUN apk update && apk add --no-cache nginx openssl gettext && \
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 -out $CERT_PATH -keyout $KEY_PATH -subj "/" && \
    envsubst '${CERT_PATH} ${KEY_PATH} ${WP_URL}' < /conf.template > /etc/nginx/http.d/nginx.conf

CMD ["nginx", "-g", "daemon off;"]

