FROM ubuntu:18.04

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
RUN curl -s https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' > /etc/apt/sources.list.d/google-chrome.list
RUN apt update \
    && apt install google-chrome-stable -y
RUN mkdir /cache
RUN apt install ssh -y \
    && eval $(ssh-agent) \
    && ssh-add key \
    && npm install

ENTRYPOINT ["node", "server.js"]

