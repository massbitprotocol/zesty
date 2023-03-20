rm -rf /tmp/zesty
mkdir /tmp/zesty
cd /tmp/zesty
git clone --quiet https://github.com/massbitprotocol/zesty.git -b $1 /tmp/zesty

cp -r /tmp/zesty/openresty /usr/local/

ln -sf /usr/local/openresty/nginx/sbin/nginx /usr/bin/nginx
cp  /tmp/zesty/nginx/conf/nginx.conf  /usr/local/openresty/nginx/conf/nginx.conf

cp -r /tmp/zesty/nginx/conf/include /usr/local/openresty/nginx/conf/extensions/
cp -r /tmp/zesty/nginx/conf/subconf /usr/local/openresty/nginx/conf/extensions/
cp -r /tmp/zesty/nginx/modules/* /usr/local/openresty/nginx/modules/extensions/

cp -r /tmp/zesty/nginx/luascripts/* /usr/local/openresty/lualib/mbr/

# load supervisor config and start
cp -r /tmp/zesty/volume/conf/supervisord/openresty.conf   /etc/supervisor/conf.d/openresty.conf

supervisorctl update
supervisorctl start openresty