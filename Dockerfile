FROM openresty/openresty:latest

RUN apt-get update \
    && apt-get install -y git \
    && cd /usr/local/openresty/lualib/resty \
    && git clone https://github.com/openresty/lua-resty-jit-uuid.git
