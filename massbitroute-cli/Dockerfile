FROM golang:1.20.2-alpine3.17

ARG BUILD_ENV
ARG TARGET_OS
ARG TARGET_ARCHITECTURE

WORKDIR /app

COPY . .

RUN apk add binutils nginx vim bash

RUN chmod +x ./build.sh

RUN ./build.sh $BUILD_ENV $TARGET_OS $TARGET_ARCHITECTURE

COPY test/gateway.conf /etc/nginx/http.d/default.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]