FROM alpine:latest

# IMAGE ARGUMENTS PASSED IN FROM BUILDER
ARG TARGETARCH
ARG BUILDDATE
ARG BUILDVERSION

# set timezone from ENVs
RUN export TZ=/usr/share/zoneinfo/${TZ}
ENV TZ=UTC

# INSTALL ADDITIONAL IMAGE DEPENDENCIES AND COPY APPLICATION TO IMAGE
RUN apk update
RUN apk add --no-cache \
    sqlite \
    curl \
    bash \
    tzdata \
    openssl \
    nano \
    nodejs \
    npm \
    tzdata

#File for portainer
RUN mkdir -p /src
RUN mkdir -p /portainer
COPY package.json /
COPY src/*.js /src

#File for dropbox
COPY dropbox_uploader.sh /
COPY backup.sh /
COPY entrypoint.sh /
COPY dropbox_uploader.sh /
WORKDIR /

RUN chmod +x /entrypoint.sh && \
    chmod +x /backup.sh && \
    chmod +x /dropbox_uploader.sh

VOLUME "/backup"

RUN npm install --silent

# DEFAULT ENV VARIABLE VALUES
ENV PORTAINER_BACKUP_URL="http://portainer:9000"
ENV PORTAINER_BACKUP_TOKEN=""
ENV PORTAINER_BACKUP_DIRECTORY="/portainer"
ENV PORTAINER_BACKUP_FILENAME="/portainer-backup.tar.gz"
ENV PORTAINER_BACKUP_OVERWRITE=false
ENV PORTAINER_BACKUP_CONCISE=false
ENV PORTAINER_BACKUP_DEBUG=false
ENV PORTAINER_BACKUP_DRYRUN=false
ENV PORTAINER_BACKUP_STACKS=false

RUN echo "0 0 * * * /backup.sh" > /etc/crontabs/root

ENTRYPOINT ["/entrypoint.sh"]
