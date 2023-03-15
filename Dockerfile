FROM openresty/openresty:1.19.9.1-14-focal

RUN apt-get update -y

RUN apt-get install vim -y

# Bundle src
COPY volume/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf

COPY volume/modules.conf /usr/local/openresty/nginx/conf/modules.conf

COPY volume/conf /usr/local/openresty/nginx/conf/include

COPY volume/conf/subconf /usr/local/openresty/nginx/conf/subconf

COPY volume/data /usr/local/openresty/nginx/data

COPY volume/logs /usr/local/openresty/nginx/logs

COPY volume/modules /usr/local/openresty/nginx/extensions

COPY volume/tmp /usr/local/openresty/nginx/tmp

COPY volume/scripts /usr/local/openresty/scripts

COPY volume/mbr /.mbr

# WORKDIR /app
# # Bundle env
# COPY .env ./.env

# # Bundle init script
# COPY ./init_container.sh ./init_container.sh 
# RUN chmod +x ./init_container.sh 


# # Get mbr cli
# WORKDIR /.mbr/bin
# RUN wget https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr



CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]