# Specify env
ENV=dev

# Get latest tag
git ls-remote --tags --sort='v:refname' git@github.com:massbitprotocol/zesty.git| tail -n1 | cut -d/ -f3 > ZESTY_TAG

# Get the version of ZESTY from tag
ZESTY_TAG=$(cat ZESTY_TAG)
# ZESTY_TAG=$(curl -q https://raw.githubusercontent.com/massbitprotocol/zesty/release/version | grep ZESTY | cut -d"=" -f2)

# Get the version of JUICY based on version from ZESTY
JUICY_TAG=$(curl -q https://raw.githubusercontent.com/massbitprotocol/zesty/release/version | grep JUICY | cut -d"=" -f2)

# Get latest tag
git fetch --all --tags --force

# Checkout latest tag
git checkout tags/${ZESTY_TAG}

# Build docker images
docker build -f ./Dockerfile -t massbit/massbitroute_zesty:${ZESTY_TAG} --build-arg JUICY_TAG=${JUICY_TAG} --build-arg ENV=${ENV} ../..

# Rerun container
bash -x restart_container.sh $ZESTY_TAG

# docker-compose up -d --force-recreate