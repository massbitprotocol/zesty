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
    "SSL")
        ;;
    *)
        ;;
    esac



done < VERSION_INFO
