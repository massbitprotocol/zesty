#!/bin/bash
curl -q https://raw.githubusercontent.com/massbitprotocol/zesty/release/version -o VERSION_INFO

# check Zesty + Juicy + SSL production tag

while IFS='=' read -r key value; do

    case $key in
    "ZESTY")
        bash /usr/local/openresty/script/update-zesty.sh $value
        ;;
    "JUICY")
        bash /usr/local/openresty/script/update-juicy.sh $value
        ;;
    "SSL")
        ;;
    *)
        ;;
    esac



done < VERSION_INFO
