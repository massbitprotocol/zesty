#!bin/bash
# Get image tag name
ZESTY_TAG=$1

# Specify ENV
ENV=$2

case $ENV in
  "stg")
    ENV=".staging"
    juicy_config_env=$ENV
    ;;
  "dev")
    ENV=".dev"
    juicy_config_env=$ENV
    ;;
  *)
    ENV=""
    juicy_config_env="production"
    ;;
esac

# Get the version of JUICY based on version from ZESTY
JUICY_TAG=$(curl -q https://raw.githubusercontent.com/massbitprotocol/version/release/version$ENV | grep JUICY | cut -d"=" -f2)

# Get the version of JUICY based on version from ZESTY
ZESTY_SO_TAG=$(curl -q https://raw.githubusercontent.com/massbitprotocol/version/release/version$ENV | grep ZESTY_SO | cut -d"=" -f2)

# Get the version of JUICY based on version from ZESTY
ZESTY_NGINX_SO_TAG=$(curl -q https://raw.githubusercontent.com/massbitprotocol/version/release/version$ENV | grep ZESTY_NGINX_SO | cut -d"=" -f2)

# Build docker image
docker build -f ./Dockerfile -t massbit/massbitroute_zesty:${ZESTY_TAG} --build-arg JUICY_TAG=${JUICY_TAG} --build-arg ZESTY_SO_TAG=${ZESTY_SO_TAG} --build-arg ZESTY_NGINX_SO_TAG=${ZESTY_NGINX_SO_TAG} --build-arg JUICY_ENV=${juicy_config_env} ..

# Push docker image
docker push massbit/massbitroute_zesty:${ZESTY_TAG}