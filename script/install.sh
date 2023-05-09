#!/bin/bash
GREY='\033[0;37m'
NC='\033[0m'

if [ "$1" == "testnet" ]; then
	juicy_config_env="staging"
	version_env=".staging"
else
    juicy_config_env="production"
fi

# Print grey text
echo -e "${GREY}Massbit Gateway Client installation in progress${NC}"

# Remove old config
supervisorctl stop all > /dev/null 2>&1
rm /tmp/zesty/ -r > /dev/null 2>&1
rm /usr/local/openresty -rf > /dev/null 2>&1
rm /etc/supervisor/conf.d/openresty.conf > /dev/null 2>&1
supervisorctl update > /dev/null 2>&1
# rm datasource to stop bind address to this file
rm /tmp/mbr_datasources.sock > /dev/null 2>&1
# rm mbr binary
rm -rf /.mbr > /dev/null 2>&1
rm /usr/bin/mbr > /dev/null 2>&1
kill -9 $(ps aux | grep '[n]ginx' | awk '{print $2}') > /dev/null 2>&1
echo "" | crontab

# Check env and apply env
if ! grep -q "MBR_CONFIG_FILE" ~/.bashrc; then
  echo "export MBR_CONFIG_FILE=/.mbr/env.yaml" >> ~/.bashrc
fi

if ! grep -q "MBR_CONFIG_FILE" /etc/environment; then
  echo "MBR_CONFIG_FILE=/.mbr/env.yaml" >> /etc/environment
fi

source ~/.bashrc
source /etc/environment

# Install dependencies

_ubuntu() {
	apt-get update -qq
    apt-get install -y curl gnupg2 ca-certificates lsb-release git make build-essential supervisor logrotate -qq

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

wget -q https://raw.githubusercontent.com/massbitprotocol/version/release/version$version_env -O VERSION_INFO

zesty_version=$(cat VERSION_INFO | grep '^ZESTY=' | cut -d = -f2 )
juicy_version=$(cat VERSION_INFO | grep '^JUICY=' | cut -d = -f2 )
so_zesty_version=$(cat VERSION_INFO | grep '^ZESTY_SO=' | cut -d = -f2 )
so_zesty_nginx_version=$(cat VERSION_INFO | grep '^ZESTY_NGINX_SO=' | cut -d = -f2 )

# load modules so
rm -rf /tmp/zesty
mkdir /tmp/zesty
git clone --quiet https://github.com/massbitprotocol/zesty.git /tmp/zesty
cd /tmp/zesty
git fetch --tags 
git checkout $zesty_version --quiet 

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
mkdir -p /.mbr
wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/go-build/zesty-$so_zesty_version -O /.mbr/zesty
chmod +x /.mbr/zesty
# load supervisor config and start
cp -r /tmp/zesty/supervisord/openresty.conf   /etc/supervisor/conf.d/openresty.conf
cp -r /tmp/zesty/supervisord/so-zesty-jr.conf   /etc/supervisor/conf.d/so-zesty-jr.conf

cp -r /tmp/zesty/script /usr/local/openresty/

# echo $so_zesty_nginx_version > /usr/local/openresty/nginx/modules/extensions/zesty_ngx.ver
echo $so_zesty_version > /.mbr/zesty.ver

supervisorctl update > /dev/null 2>&1
supervisorctl start openresty > /dev/null 2>&1
supervisorctl start so-zesty-jr > /dev/null 2>&1

sleep 2

GREEN='\033[0;32m'
CHECK='\xE2\x9C\x94'
RESET='\033[0m'
RED='\033[0;31m'

# Print green check mark symbol
if supervisorctl status openresty | grep -q "RUNNING"; then
    echo -e "${GREEN}${CHECK} Massbit Gateway client installed successfully ${RESET}"
else
	echo -e "${RED}✖ Failed to install Massbit Gateway client. Please reboot your host and rerun the installation command $1${NC}${RESET}"
	exit 1
fi

if [ "$1" == "testnet" ]; then
	(crontab -l ; echo "*/5 * * * * bash /usr/local/openresty/script/cronjob.sh version.staging") | crontab
else
	(crontab -l ; echo "*/5 * * * * bash /usr/local/openresty/script/cronjob.sh version") | crontab
fi

wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/juicy-config/env.yaml.$juicy_config_env -O /.mbr/env.yaml

# Load and run CLIty/      
wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr-$juicy_version -O /.mbr/mbr
chmod +x  /.mbr/mbr
ln -sf /.mbr/mbr /usr/bin/mbr

rm /tmp/mbr_datasources.sock
kill -9 $(ps aux | grep '[n]ginx' | awk '{print $2}')


cp -r /tmp/zesty/logrotate/logrotate.conf /etc/logrotate.d/mbr_logrotate.conf

/.mbr/mbr login
/.mbr/mbr gateway run
