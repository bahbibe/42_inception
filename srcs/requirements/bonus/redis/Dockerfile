FROM alpine:3.23

RUN apk update && apk add --no-cache redis

CMD ["redis-server", "--protected-mode", "no"]

