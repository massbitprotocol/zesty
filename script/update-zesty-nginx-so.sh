#!/bin/bash

update_zesty (){
    wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/c-build/ngx_http_zesty_module-$1.so -O /usr/local/openresty/nginx/modules/extensions/ngx_http_zesty_module-$1.so
    
    wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/c-build/md5-ngx_http_zesty_module-$1.so -O /usr/local/openresty/nginx/modules/extensions/md5-ngx_http_zesty_module-$1.so

    # Path to the file to be checked
    file_to_check="/usr/local/openresty/nginx/modules/extensions/ngx_http_zesty_module-$1.so"

    # Path to the file containing the correct MD5 hash
    hash_file="/usr/local/openresty/nginx/modules/extensions/md5-ngx_http_zesty_module-$1.so"

    # Read the correct hash from the hash file
    correct_hash=$(cat "$hash_file")

    # Calculate the hash of the file to be checked
    calculated_hash=$(md5sum "$file_to_check" | awk '{print $1}')

    # Compare the calculated hash with the correct hash
    if [ "$calculated_hash" == "$correct_hash" ]; then
        rm /usr/local/openresty/nginx/modules/extensions/ngx_http_zesty_module.so
        cp /usr/local/openresty/nginx/modules/extensions/ngx_http_zesty_module-$1.so /usr/local/openresty/nginx/modules/extensions/ngx_http_zesty_module.so
        echo "$(date) - ngx_http_zesty_module.so updated successfully - $1"
    else
        echo "$(date) - Failed to update ngx_http_zesty_module.so to $1"
    fi

    export LD_LIBRARY_PATH=/usr/local/openresty/nginx/modules/extensions
    export MBR_CONFIG_FILE=/.mbr/env.yaml
    supervisorctl restart openresty
    mkdir -p /var/run/nginx-client-body

    echo "$(date) - ngx_http_zesty_module.so updated successfully - $1"
    exit 0
}


folder_path="/usr/local/openresty/nginx/modules/extensions/zesty_ngx.ver"

if [ ! -f $folder_path ] || [ $(cat $folder_path) != $1 ]; then
    supervisorctl stop openresty
    update_zesty $1
else 
    echo "$(date) - ngx_http_zesty_module.so is up to date - $1"
    exit 0
fi
