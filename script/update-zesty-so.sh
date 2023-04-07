#!/bin/bash

update_zesty (){
    wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/go-build/zesty-$1.so -O /usr/local/openresty/nginx/modules/extensions/zesty-$1.so
    export LD_LIBRARY_PATH=/usr/local/openresty/nginx/modules/extensions
    echo $1 > /usr/local/openresty/nginx/modules/extensions/zesty.ver
    supervisorctl restart openresty
    mkdir -p /var/run/nginx-client-body

    echo "$(date) - Zesty.so updated successfully"
    exit 0
}


folder_path="/usr/local/openresty/nginx/modules/extensions/zesty.ver"

if [ ! -f $folder_path ] || [ $(cat $folder_path) != $1 ]; then
    update_zesty $1
else 
    echo "$(date) - Zesty.so is up to date"
    exit 0
fi
