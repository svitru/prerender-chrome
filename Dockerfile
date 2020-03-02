FROM selenium/standalone-chrome:3.12.0
USER root

ENV PORT 3002
ENV CACHE_LIVE_TIME 604800
ENV CACHE_ROOT_DIR /cache
ENV GIT_SSH_COMMAND ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

EXPOSE ${PORT}

WORKDIR /app
ADD . /app

RUN apt update \
    && apt install git curl -y \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install nodejs -y
RUN mkdir /cache
RUN apt install ssh -y \
    && eval $(ssh-agent) \
    && ssh-add key \
    && npm install

ENTRYPOINT ["node", "server.js"]

