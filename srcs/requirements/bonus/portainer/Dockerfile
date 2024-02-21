FROM alpine:3.18

ARG BIN="https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz"

RUN apk update && apk add --no-cache wget tar && wget $BIN && tar -xvf portainer-2.19.4-linux-amd64.tar.gz && rm portainer-2.19.4-linux-amd64.tar.gz

CMD [ "./portainer/portainer"]
