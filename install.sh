#!/bin/bash

# Update package lists
apt update

# Install dependencies

_ubuntu() {
	apt-get update
	# apt-get install -y \
	# 	supervisor ca-certificates curl rsync apt-utils git python3 python3-pip parallel apache2-utils jq python-is-python2 libssl-dev libmaxminddb-dev fcgiwrap cron xz-utils liburcu-dev libev-dev libsodium-dev libtool libunwind-dev libmaxminddb-dev 
    apt-get install -y curl gnupg2 ca-certificates lsb-release git make build-essential

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

IP="$(curl http://ipv4.icanhazip.com)"

if [ -z "$IP" ]; then
	echo "Your IP is unknown"
	exit 1
fi

# update install openresty


# # Add OpenResty GPG key
# curl -L https://openresty.org/package/pubkey.gpg | apt-key add -

# # Add OpenResty repository
# echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/openresty.list

# # Update package lists again
# apt update

# # Install OpenResty
# apt-get install openresty=1.19.9.1-1~$(lsb_release -sc) -y


# # Print version info
# echo "OpenResty $(openresty -v | cut -d ' ' -f 2) installed successfully!"


# load modules so
rm -rf /tmp/zesty
mkdir /tmp/zesty
git clone https://github.com/massbitprotocol/zesty.git -b hoang-dev /tmp/zesty

mkdir -p /etc/nginx/conf.d
mkdir -p /usr/local/openresty/nginx/extensions
mkdir -p /usr/local/openresty/nginx/conf
mkdir -p /var/run/openresty/nginx-client-body

cp -r /tmp/zesty/volume/bin/openresty /usr/local/

cp -r /tmp/zesty/volume/bin/openresty/nginx/sbin/nginx /usr/bin/
cp -r /tmp/zesty/volume/nginx.conf   /usr/local/openresty/nginx/conf/nginx.conf
cp -r /tmp/zesty/volume/modules.conf   /usr/local/openresty/nginx/conf/modules.conf
cp -r /tmp/zesty/volume/conf   /etc/nginx/conf.d
cp -r /tmp/zesty/volume/ssl   /etc/gateway/ssl
cp -r /tmp/zesty/volume/data   /usr/local/openresty/nginx/data
cp -r /tmp/zesty/volume/modules/*   /usr/local/openresty/nginx/extensions
cp /tmp/zesty/volume/conf/systemd/openresty.service  /etc/systemd/system/openresty.service

systemctl daemon-reload
systemctl start openresty
