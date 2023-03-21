ZESTY_TAG=$1

# Gen docker-compose
cat ./docker-compose.yaml.tpl | \
    sed "s/\[\[ZESTY_TAG\]\]/$ZESTY_TAG/g" \
    > ./docker-compose.yaml

# Restart container
docker-compose up -d --force-recreate