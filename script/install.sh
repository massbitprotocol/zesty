#!/bin/bash

# Remove old config
supervisorctl stop all > /dev/null
rm /tmp/zesty/ -r > /dev/null
rm /usr/local/openresty -rf > /dev/null
rm /etc/supervisor/conf.d/openresty.conf > /dev/null
supervisorctl update > /dev/null
# rm datasource to stop bind address to this file
rm /tmp/mbr_datasources.sock > /dev/null
# rm mbr binary
rm -rf /.mbr > /dev/null
rm /usr/bin/mbr > /dev/null
kill -9 $(ps aux | grep '[n]ginx' | awk '{print $2}')
echo "" | crontab

if ! grep -q "MBR_CONFIG_FILE" ./.bashrc; then
  echo "export MBR_CONFIG_FILE=/.mbr/env.yaml" >> ./.bashrc
fi

# Install dependencies

_ubuntu() {
	apt-get -qq update 
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

wget -q https://raw.githubusercontent.com/massbitprotocol/zesty/release/version -O VERSION_INFO

zesty_version=$(cat VERSION_INFO | grep '^ZESTY=' | cut -d = -f2 )
juicy_version=$(cat VERSION_INFO | grep '^JUICY=' | cut -d = -f2 )
so_zesty_version=$(cat VERSION_INFO | grep '^ZESTY_SO=' | cut -d = -f2 )
so_zesty_nginx_version=$(cat VERSION_INFO | grep '^ZESTY_NGINX_SO=' | cut -d = -f2 )

# load modules so
rm -rf /tmp/zesty
mkdir /tmp/zesty
git clone --quiet https://github.com/massbitprotocol/zesty.git -b $zesty_version /tmp/zesty

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

wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/c-build/ngx_http_zesty_module-$so_zesty_nginx_version.so -O /usr/local/openresty/nginx/modules/extensions/ngx_http_zesty_module.so
wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/go-build/zesty-$so_zesty_version.so -O /usr/local/openresty/nginx/modules/extensions/zesty-$so_zesty_version.so

# load supervisor config and start
cp -r /tmp/zesty/supervisord/openresty.conf   /etc/supervisor/conf.d/openresty.conf
cp -r /tmp/zesty/script /usr/local/openresty/

# echo $so_zesty_nginx_version > /usr/local/openresty/nginx/modules/extensions/zesty_ngx.ver
echo $so_zesty_version > /usr/local/openresty/nginx/modules/extensions/zesty.ver

supervisorctl update
supervisorctl start openresty

(crontab -l ; echo "*/5 * * * * bash /usr/local/openresty/script/cronjob.sh") | crontab

mkdir -p /.mbr
wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/juicy-config/env.yaml.staging -O /.mbr/env.yaml

# Load and run CLIty/      
wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr-$juicy_version -O /.mbr/mbr
chmod +x  /.mbr/mbr
ln -sf /.mbr/mbr /usr/bin/mbr

rm /tmp/mbr_datasources.sock
kill -9 $(ps aux | grep '[n]ginx' | awk '{print $2}')

/.mbr/mbr login
/.mbr/mbr gateway init