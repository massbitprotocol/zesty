# Specify env
ENV=dev

# Get the version
ZESTY_TAG=$(curl -q https://raw.githubusercontent.com/massbitprotocol/zesty/release/version | grep ZESTY | cut -d"=" -f2)
JUICY_TAG=$(curl -q https://raw.githubusercontent.com/massbitprotocol/zesty/release/version | grep JUICY | cut -d"=" -f2)

# Build docker images
docker build -f ./Dockerfile -t massbit/massbitroute_zesty:${ZESTY_TAG} --build-arg JUICY_TAG=${JUICY_TAG} --build-arg ENV=${ENV} ../..

# docker-compose up -d --force-recreate