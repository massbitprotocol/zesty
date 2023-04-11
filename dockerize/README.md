# Build docker image for testing
docker build -f ./Dockerfile -t massbit/massbitroute_zesty:v0.0.1-dev --build-arg JUICY_TAG=v0.0.9 --build-arg ZESTY_SO_TAG=v0.0.5 --build-arg ZESTY_NGINX_SO_TAG=v0.0.6 .. --no-cache --progress=plain

# Start container in root folder
docker-compose up -d --force-recreate

# Start container with env
docker run --name mbr_gateway -p 80:80 -p 443:443 -e TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIwZmE0MDZiYy01NTYxLTQxNDUtYmIzMi04ZjFiYWU1ZTM4ZjMiLCJpYXQiOjE2ODExODY5NDAsImV4cCI6MTY4MTc5MTc0MH0.9Ys5EYwP3D3wLc1WcNFW4b5yXOeZ1MIRSUDr9loxKb4 -e GW_ID=85618003-3c89-41ed-9a42-7f80e8238c92 massbit/massbitroute_zesty:v0.0.1-dev