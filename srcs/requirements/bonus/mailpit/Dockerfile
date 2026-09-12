FROM alpine:3.23

ARG MAILPIT_URL="https://github.com/axllent/mailpit/releases/download/v1.31.1/mailpit-linux-amd64.tar.gz"

RUN apk add --no-cache wget && \
	wget $MAILPIT_URL -O /tmp/mailpit.tar.gz && \
	tar -xzf /tmp/mailpit.tar.gz -C /usr/local/bin mailpit && \
	rm /tmp/mailpit.tar.gz

# smtp on 1025 for the other containers, web ui on 8025
ENV MP_SMTP_BIND_ADDR=0.0.0.0:1025 \
	MP_UI_BIND_ADDR=0.0.0.0:8025 \
	MP_DATABASE=/data/mailpit.db

CMD ["mailpit"]
