#!/bin/bash
export LD_LIBRARY_PATH=/usr/local/openresty/nginx/modules/extensions
rm /tmp/mbr_datasources.sock
kill -9 $(ps aux | grep '[n]ginx' | awk '{print $2}')
/usr/local/openresty/nginx/sbin/nginx -c /usr/local/openresty/nginx/conf/nginx.conf -g 'daemon off;'