FROM alpine:3.23

RUN apk add --no-cache nginx

COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf
COPY ./src/ /var/www/html/website

CMD ["nginx", "-g", "daemon off;"]
