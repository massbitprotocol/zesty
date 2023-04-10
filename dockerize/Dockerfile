FROM openresty/openresty:1.19.9.1-14-focal

ARG JUICY_TAG
ARG ZESTY_SO_TAG
ARG ZESTY_NGINX_SO_TAG
ARG ENV

RUN apt-get update -y

RUN apt-get install vim dnsutils curl supervisor -y

# Bundle src
COPY nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

COPY nginx/conf/include /usr/local/openresty/nginx/conf/extensions/include

COPY nginx/conf/subconf /usr/local/openresty/nginx/conf/extensions/subconf
 
COPY nginx/modules /usr/local/openresty/nginx/modules/extensions

COPY nginx/luascripts /usr/local/openresty/lualib/mbr

# Get mbr cli
WORKDIR /.mbr/executable
RUN wget https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr-${JUICY_TAG}
RUN mv ./mbr-${JUICY_TAG} ./mbr
RUN chmod +x ./mbr
RUN ln -s /.mbr/executable/mbr /usr/bin/mbr

# Get so module to nginx
WORKDIR /usr/local/openresty/nginx
RUN wget https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/go-build/zesty-${ZESTY_SO_TAG}.so -O /usr/local/openresty/nginx/modules/extensions/zesty-${ZESTY_SO_TAG}.so

RUN wget https://public-massbit.s3.ap-southeast-1.amazonaws.com/so-zesty/c-build/ngx_http_zesty_module-${ZESTY_NGINX_SO_TAG}.so -O /usr/local/openresty/nginx/modules/extensions/ngx_http_zesty_module.so

RUN echo "${ZESTY_SO_TAG}" > /usr/local/openresty/nginx/modules/extensions/zesty.ver

# Get supervisor conf and start openresty config
COPY supervisord/openresty.conf /etc/supervisor/conf.d/openresty.conf
COPY script/start-openresty-docker.sh /usr/local/openresty/script/start-openresty.sh
RUN chmod +x /usr/local/openresty/script/start-openresty.sh

EXPOSE 80

# CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]
CMD ["/usr/bin/supervisord", "-n"]