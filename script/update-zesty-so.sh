#!/bin/bash

update_zesty (){
    supervisorctl stop so-zesty-jr
    wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/go-build/zesty-$1 -O /.mbr/zesty
    export LD_LIBRARY_PATH=/usr/local/openresty/nginx/modules/extensions
    chmod +x /.mbr/zesty
    echo $1 > /.mbr/zesty.ver
    supervisorctl start so-zesty-jr
    # nginx -s reload
    # mkdir -p /var/run/nginx-client-body

    echo "$(date) - Zesty binary updated successfully - $1"
    exit 0
}


folder_path="/.mbr/zesty.ver"

if [ ! -f $folder_path ] || [ $(cat $folder_path) != $1 ]; then
    update_zesty $1
else 
    echo "$(date) - Zesty binary is up to date - $1"
    exit 0
fi
