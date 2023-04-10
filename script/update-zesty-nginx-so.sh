#!/bin/bash

update_zesty (){
wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/c-build/ngx_http_zesty_module-$1.so -O /usr/local/openresty/nginx/modules/extensions/ngx_http_zesty_module.so
    export LD_LIBRARY_PATH=/usr/local/openresty/nginx/modules/extensions
    supervisorctl restart openresty
    mkdir -p /var/run/nginx-client-body

    echo "$(date) - ngx_http_zesty_module.so updated successfully"
    exit 0
}


folder_path="/usr/local/openresty/nginx/modules/extensions/zesty_ngx.ver"

if [ ! -f $folder_path ] || [ $(cat $folder_path) != $1 ]; then
    update_zesty $1
else 
    echo "$(date) - ngx_http_zesty_module.so is up to date"
    exit 0
fi