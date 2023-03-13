FROM golang:1.20.2-alpine3.17

ARG BUILD_ENV

WORKDIR /app

COPY . .

RUN apk add --update --no-cache binutils nginx vim bash

RUN chmod +x ./build.sh

RUN ./build.sh $BUILD_ENV $TARGET_OS $TARGET_ARCHITECTURE

COPY test/gateway.conf /etc/nginx/sites-enabled/default

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]