#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/openresty/nginx/modules/extensions
/usr/bin/nginx -c /usr/local/openresty/nginx/conf/nginx.conf -g 'daemon off;'
