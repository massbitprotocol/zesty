FROM golang:1.19.2-bullseye as development

WORKDIR /app

COPY . .

# nginx
RUN apt update && apt install nginx -y 
RUN apt update && apt install nginx  rsync -y 
COPY test/gateway.conf /etc/nginx/sites-enabled/default
RUN nginx -s reload