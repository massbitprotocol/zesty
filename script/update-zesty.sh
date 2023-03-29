#!/bin/bash


echo "Zesty last update at $(date)" > /usr/local/openresty/zesty-update.log

set -e
rm -rf /tmp/zesty
mkdir /tmp/zesty
git clone --quiet https://github.com/massbitprotocol/zesty.git -b $1 /tmp/zesty


cp -r /tmp/zesty/volume/bin/openresty /usr/local/

cp -r /tmp/zesty/volume/bin/openresty/nginx/sbin/nginx /usr/bin/
cp -r /tmp/zesty/volume/nginx.conf   /usr/local/openresty/nginx/conf/nginx.conf
cp -r /tmp/zesty/volume/modules.conf   /usr/local/openresty/nginx/conf/modules.conf
cp -r /tmp/zesty/volume/data   /usr/local/openresty/nginx/data
cp -r /tmp/zesty/volume/modules/*   /usr/local/openresty/nginx/extensions
chmod 755 /usr/local/openresty/nginx/data/vts_gw.db

cp -r /tmp/zesty/volume/conf   /usr/local/openresty/nginx/conf/include
cp -r /tmp/zesty/volume/conf/subconf   /usr/local/openresty/nginx/conf/subconf

cp -r /tmp/zesty/volume/mbr/ssl   /etc/gateway/
cp -r /tmp/zesty/volume/mbr/ssl   /.mbr/
cp -r /tmp/zesty/volume/mbr/util /.mbr/

/usr/bin/nginx -s reload