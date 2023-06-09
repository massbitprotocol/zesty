#!/bin/sh
mkdir -p /usr/local/openresty/nginx/certs

wget -O /usr/local/openresty/nginx/certs/gw-fullchain.pem https://public-massbit.s3.ap-southeast-1.amazonaws.com/certs/gw/gw-fullchain.pem
wget -O /usr/local/openresty/nginx/certs/gw-privkey.pem https://public-massbit.s3.ap-southeast-1.amazonaws.com/certs/gw/gw-privkey.pem

wget -O /usr/local/openresty/nginx/certs/internal-fullchain.pem https://public-massbit.s3.ap-southeast-1.amazonaws.com/certs/gw/internal-fullchain.pem
wget -O /usr/local/openresty/nginx/certs/internal-privkey.pem https://public-massbit.s3.ap-southeast-1.amazonaws.com/certs/gw/internal-privkey.pem