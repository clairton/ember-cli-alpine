FROM node:alpine

MAINTAINER Clairton Rodrigo Heinzen <clairton.rodrigo@gmail.com>

RUN apk add --update --no-cache git

RUN mkdir -p /app
WORKDIR /app

# Install ember-cli
RUN yarn global add ember-cli

# Allow SSH keys to be mounted (optional, but nice if you use SSH authentication for git)
VOLUME /root/.ssh
VOLUME /app

# install deps
RUN yarn

# Install chromium to run tests
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --no-cache --update \
      chromium@edge \
      nss@edge

# test server on port 5779
EXPOSE 4200 7020 5779

# run ember server on container start
CMD ember server --live-reload-port 5779 --watcher polling --host 0.0.0.0
