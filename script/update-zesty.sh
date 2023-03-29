#!/bin/bash


echo "Zesty last update at $(date)" > /usr/local/openresty/zesty-update.log

set -e
rm -rf /tmp/zesty
git clone --quiet https://github.com/massbitprotocol/zesty.git -b $1 /tmp/zesty

cp  /tmp/zesty/nginx/conf/nginx.conf  /usr/local/openresty/nginx/conf/nginx.conf
cp -r /tmp/zesty/nginx/conf/include /usr/local/openresty/nginx/conf/extensions/
cp -r /tmp/zesty/nginx/conf/subconf /usr/local/openresty/nginx/conf/extensions/
cp -r /tmp/zesty/nginx/modules/* /usr/local/openresty/nginx/modules/extensions/
cp -r /tmp/zesty/nginx/modules/* /usr/local/openresty/nginx/extensions/


cp -r /tmp/zesty/nginx/luascripts/* /usr/local/openresty/lualib/mbr/

# load supervisor config and start
cp -r /tmp/zesty/supervisord/openresty.conf   /etc/supervisor/conf.d/openresty.conf



/usr/bin/nginx -s reload