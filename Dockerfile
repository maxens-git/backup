FROM alpine:latest

RUN apk update
RUN apk add --no-cache rclone
RUN apk add --no-cache sqlite
RUN apk add --no-cache openssl

RUN mkdir /docker

COPY entrypoint.sh /
COPY backup.sh /

WORKDIR /
RUN chmod +x entrypoint.sh
RUN chmod +x backup.sh

RUN echo "0 0 * * * /backup.sh" > /etc/crontabs/root

ENTRYPOINT ["/entrypoint.sh"]
