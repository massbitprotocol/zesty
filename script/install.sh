#!/bin/bash


# Validate email parameter
if [[ ! "$1" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
  echo "Error: Invalid email format"
  exit 1
fi

# Validate string parameter 1
if [[ -z "$2" ]]; then
  echo "Error: Password is required"
  exit 1
fi

# Validate string parameter 2
if [[ -z "$3" ]]; then
  echo "Error: Node/Gateway ID is required"
  exit 1
fi


# Install dependencies

_ubuntu() {
	apt-get update -qq
	# apt-get install -y \
	# 	supervisor ca-certificates curl rsync apt-utils git python3 python3-pip parallel apache2-utils jq python-is-python2 libssl-dev libmaxminddb-dev fcgiwrap cron xz-utils liburcu-dev libev-dev libsodium-dev libtool libunwind-dev libmaxminddb-dev 
    apt-get install -y curl gnupg2 ca-certificates lsb-release git make build-essential supervisor -qq

}
# check ubuntu
if [ -f /etc/os-release ]; then
	. /etc/os-release
	OS=$NAME
	VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
	OS=$(lsb_release -si)
	VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
	. /etc/lsb-release
	OS=$DISTRIB_ID
	VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
	OS=Debian
	VER=$(cat /etc/debian_version)

fi
if [ \( "$OS" = "Ubuntu" \) -a \( "$VER" = "20.04" \) ]; then
	_ubuntu
else
	echo "Ubuntu 20.04 is required "
	exit 0
fi


# load modules so
rm -rf /tmp/zesty
mkdir /tmp/zesty
cd /tmp/zesty
git clone --quiet https://github.com/massbitprotocol/zesty.git -b master /tmp/zesty

mkdir -p /etc/nginx/conf.d
mkdir -p /usr/local/openresty/nginx/extensions
mkdir -p /usr/local/openresty/nginx/conf
mkdir -p /var/run/openresty/nginx-client-body
mkdir -p /etc/gateway/
mkdir -p /usr/local/openresty/nginx/logs/stat/ 
mkdir -p /.mbr/logs/stat

cp -r /tmp/zesty/openresty /usr/local/

cp -r /tmp/zesty/openresty/nginx/sbin/nginx /usr/bin/
cp -r /tmp/zesty/volume/nginx.conf   /usr/local/openresty/nginx/conf/nginx.conf
cp -r /tmp/zesty/volume/modules.conf   /usr/local/openresty/nginx/conf/modules.conf
cp -r /tmp/zesty/volume/data   /usr/local/openresty/nginx/data
cp -r /tmp/zesty/volume/modules/*   /usr/local/openresty/nginx/extensions
chmod 755 /usr/local/openresty/nginx/data/vts_gw.db

cp -r /tmp/zesty/volume/conf   /usr/local/openresty/nginx/conf/include
cp -r /tmp/zesty/volume/conf/subconf   /usr/local/openresty/nginx/conf/subconf

cp -r /tmp/zesty/volume/mbr/ssl   /etc/gateway/
cp -r /tmp/zesty/volume/mbr/ssl   /.mbr/
cp -r /tmp/zesty/volume/mbr/util /.mbr/

# load supervisor config and start
cp -r /tmp/zesty/volume/conf/supervisord/openresty.conf   /etc/supervisor/conf.d/openresty.conf

supervisorctl update
supervisorctl start openresty

# Load and run CLI
wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr -O /.mbr/mbr
chmod +x  /.mbr/mbr
/.mbr/mbr login -e $1 -p $2 -f

/.mbr/mbr gateway boot --id $3