#!/bin/bash

update_zesty (){
    echo "Zesty last update at $(date)" > /usr/local/openresty/zesty-update.log

    rm -rf /tmp/zesty
    git clone --quiet https://github.com/massbitprotocol/zesty.git -b $1 /tmp/zesty
    cp -r /tmp/zesty/script /usr/local/openresty/

    cp  /tmp/zesty/nginx/conf/nginx.conf  /usr/local/openresty/nginx/conf/nginx.conf
    cp -r /tmp/zesty/nginx/conf/include /usr/local/openresty/nginx/conf/extensions/
    cp -r /tmp/zesty/nginx/conf/subconf /usr/local/openresty/nginx/conf/extensions/
    cp -r /tmp/zesty/nginx/modules/* /usr/local/openresty/nginx/modules/extensions/

    #wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/c-build/ngx_http_zesty_module.so -O /usr/local/openresty/nginx/modules/extensions/ngx_http_zesty_module.so
    wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/go-build/zesty.so -O /usr/local/openresty/nginx/modules/extensions/zesty.so

    cp -r /tmp/zesty/nginx/luascripts/* /usr/local/openresty/lualib/mbr/

    # load supervisor config and start
    cp -r /tmp/zesty/supervisord/openresty.conf   /etc/supervisor/conf.d/openresty.conf

    rm /tmp/mbr_datasources.sock
    /usr/bin/nginx -s reload
    rm /tmp/mbr_datasources.sock
    echo "$(date) - Zesty updated successfully"
    exit 0
}


folder_path="/tmp/zesty"
if [ -d "$folder_path" ]; then
    # Move into the folder
    cd $folder_path
    # Get the current Git tag
    git_tag=$(git describe --tags --abbrev=0)
    
    if [ $git_tag !== $1 ]; then
        echo "$(date) - Zesty is up to date"
        exit 0
    else 
        cd /tmp
        update_zesty $1
    fi

    
else
    update_zesty $1
fi


