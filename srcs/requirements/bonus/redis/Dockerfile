FROM alpine:3.18

RUN apk update && apk add --no-cache redis

CMD ["redis-server", "--protected-mode no"]

