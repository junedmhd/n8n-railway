FROM node:20-alpine

ARG N8N_VERSION=1.99.1

# Install system dependencies
RUN apk add --update --no-cache graphicsmagick tzdata su-exec

# Create n8n user for security
RUN addgroup -g 1000 n8n && \
    adduser -u 1000 -G n8n -s /bin/sh -D n8n

# Install n8n
RUN apk --update add --virtual build-dependencies python3 build-base && \
    npm_config_user=root npm install --location=global n8n@${N8N_VERSION} && \
    apk del build-dependencies && \
    npm cache clean --force

WORKDIR /data

EXPOSE $PORT

ENV N8N_USER_ID=root

CMD export N8N_PORT=$PORT && n8n start