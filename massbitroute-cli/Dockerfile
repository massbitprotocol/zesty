FROM golang:1.19.2-bullseye

ARG BUILD_ENV

WORKDIR /app

COPY . .

RUN chmod +x ./build.sh

RUN ./build.sh $BUILD_ENV

RUN apt update && apt install nginx -y

RUN apt-get install vim -y

COPY test/gateway.conf /etc/nginx/sites-enabled/default

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]