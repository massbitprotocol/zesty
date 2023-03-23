#!/bin/bash

set -e

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

curl -q https://raw.githubusercontent.com/massbitprotocol/zesty/release/version -o VERSION_INFO

zesty_version=$(cat VERSION_INFO | grep ZESTY | cut -d = -f2 )
juicy_version=$(cat VERSION_INFO | grep JUICY | cut -d = -f2 )

# load modules so
rm -rf /tmp/zesty
mkdir /tmp/zesty
git clone --quiet https://github.com/massbitprotocol/zesty.git -b feature/cron-job /tmp/zesty

cp -r /tmp/zesty/openresty /usr/local/

ln -sf /usr/local/openresty/nginx/sbin/nginx /usr/bin/nginx
cp  /tmp/zesty/nginx/conf/nginx.conf  /usr/local/openresty/nginx/conf/nginx.conf
mkdir -p /usr/local/openresty/nginx/conf/extensions
cp -r /tmp/zesty/nginx/conf/include /usr/local/openresty/nginx/conf/extensions/
cp -r /tmp/zesty/nginx/conf/subconf /usr/local/openresty/nginx/conf/extensions/
mkdir -p /usr/local/openresty/nginx/modules/extensions
cp -r /tmp/zesty/nginx/modules/* /usr/local/openresty/nginx/modules/extensions/

mkdir -p /usr/local/openresty/lualib/mbr
cp -r /tmp/zesty/nginx/luascripts/* /usr/local/openresty/lualib/mbr/
mkdir -p /var/run/openresty/nginx-client-body
mkdir -p /etc/gateway/

# load supervisor config and start
cp -r /tmp/zesty/volume/conf/supervisord/openresty.conf   /etc/supervisor/conf.d/openresty.conf

supervisorctl update
supervisorctl start openresty

# Load and run CLI
wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr-$juicy_version -O /.mbr/mbr
chmod +x  /.mbr/mbr
/.mbr/mbr login -e $1 -p $2 -f

/.mbr/mbr gateway boot --id $3

# bash install.sh hoang@codelight.co Codelight123 23423423
