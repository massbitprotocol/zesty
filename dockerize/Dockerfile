FROM openresty/openresty:1.19.9.1-14-focal

ARG JUICY_TAG
ARG ENV

RUN apt-get update -y

RUN apt-get install vim dnsutils curl -y

# Bundle src
COPY nginx/conf/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

COPY nginx/conf/include /usr/local/openresty/nginx/conf/extensions/include

COPY nginx/conf/subconf /usr/local/openresty/nginx/conf/extensions/subconf

# COPY volume/data /usr/local/openresty/nginx/data

# COPY volume/logs /usr/local/openresty/nginx/logs
 
COPY nginx/modules /usr/local/openresty/nginx/modules/extensions

COPY nginx/luascripts /usr/local/openresty/lualib/mbr

# WORKDIR /app
# # Bundle env
# COPY .env ./.env

# # Bundle init script
# COPY ./init_container.sh ./init_container.sh 
# RUN chmod +x ./init_container.sh 


# Get mbr cli
WORKDIR /.mbr/executable
RUN wget https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr-${JUICY_TAG}
RUN mv ./mbr-${JUICY_TAG} ./mbr
RUN chmod +x ./mbr
RUN ln -s /.mbr/executable/mbr /usr/bin/mbr

WORKDIR /usr/local/openresty

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]