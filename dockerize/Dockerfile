FROM openresty/openresty:1.19.9.1-14-focal

ARG JUICY_TAG
ARG ZESTY_SO_TAG
ARG ZESTY_NGINX_SO_TAG
ARG ENV

RUN apt-get update -y

RUN apt-get install vim dnsutils curl supervisor logrotate -y

# Bundle src
COPY nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

COPY nginx/conf/include /usr/local/openresty/nginx/conf/extensions/include

COPY nginx/conf/subconf /usr/local/openresty/nginx/conf/extensions/subconf
 
COPY nginx/modules /usr/local/openresty/nginx/modules/extensions

COPY nginx/luascripts /usr/local/openresty/lualib/mbr

# Get mbr cli
WORKDIR /.mbr
RUN wget https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr-${JUICY_TAG}
RUN mv ./mbr-${JUICY_TAG} ./mbr
RUN chmod +x ./mbr
RUN ln -s /.mbr/mbr /usr/bin/mbr

# Get mbr bin env
RUN wget https://public-massbit.s3.ap-southeast-1.amazonaws.com/juicy-config/env.yaml.production -O ./env.yaml

# Get Zesty So(Go) bin
RUN wget https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/go-build/zesty-${ZESTY_SO_TAG} -O ./zesty
RUN chmod +x /.mbr/zesty

# Get ngx_http_zesty_module C to nginx
WORKDIR /usr/local/openresty/nginx

RUN wget https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/c-build/ngx_http_zesty_module-${ZESTY_NGINX_SO_TAG}.so -O /usr/local/openresty/nginx/modules/extensions/ngx_http_zesty_module.so

RUN echo "${ZESTY_SO_TAG}" > /.mbr/zesty.ver

# Get supervisor conf and start openresty config
COPY supervisord/* /etc/supervisor/conf.d/

COPY script/start-openresty-docker.sh /usr/local/openresty/script/start-openresty.sh
COPY script/init-docker.sh /usr/local/openresty/script/init.sh

RUN chmod +x /usr/local/openresty/script/start-openresty.sh
RUN chmod +x /usr/local/openresty/script/init.sh

# Get logrotate conf
COPY logrotate/logrotate.conf /etc/logrotate.d/mbr_logrotate.conf

EXPOSE 80
EXPOSE 443

# CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
CMD ["/usr/bin/supervisord", "-n"]