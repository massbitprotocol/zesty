#!/bin/bash
curl -q https://raw.githubusercontent.com/massbitprotocol/zesty/release/version -o VERSION_INFO

# check Zesty + Juicy + SSL production tag

while IFS='=' read -r key value; do
    case $key in
    "ZESTY")
        bash /usr/local/openresty/script/update-zesty.sh $value > /var/log/zesty-update.log
        ;;
    "JUICY")
        bash /usr/local/openresty/script/update-juicy.sh $value > /var/log/juicy-update.log
        ;;
    "ZESTY_NGINX_SO")
        bash /usr/local/openresty/script/update-zesty-nginx-so.sh $value > /var/log/zesty-nginx-so-update.log
        ;;
    "ZESTY_SO")
        bash /usr/local/openresty/script/update-zesty-so.sh $value > /var/log/zesty-so-update.log
        ;;
    *)
        ;;
    esac

done < VERSION_INFO
