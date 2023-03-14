FROM openresty/openresty:1.19.9.1-14-focal

RUN apt-get update -y

RUN apt-get install vim -y

COPY volume/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

COPY volume/modules.conf /usr/local/openresty/nginx/conf/modules.conf

COPY volume/conf /etc/nginx/conf.d

COPY volume/data /usr/local/openresty/nginx/data

COPY volume/logs /usr/local/openresty/nginx/logs

COPY volume/modules /usr/local/openresty/nginx/extensions

COPY volume/tmp /usr/local/openresty/nginx/tmp

COPY volume/mbr /.mbr

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]