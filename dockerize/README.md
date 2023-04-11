# Build docker image for testing
docker build -f ./Dockerfile -t massbit/massbitroute_zesty:v0.0.1-dev --build-arg JUICY_TAG=v0.0.9 --build-arg ZESTY_SO_TAG=v0.0.5 --build-arg ZESTY_NGINX_SO_TAG=v0.0.6 .. --no-cache --progress=plain

# Start container in root folder
docker-compose up -d --force-recreate

# Start container with env
docker run -e USERNAME=minh.bugfix@codelight.co -e PASSWORD=Codelight123 -e GW_ID=2dsdsa1231 massbit/massbitroute_zesty:v0.0.1-dev