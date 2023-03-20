echo "Juicy last update at $(date)" > /usr/local/openresty/juicy-update.log

wget -q https://public-massbit.s3.ap-southeast-1.amazonaws.com/binary/mbr -O /.mbr/mbr
chmod +x  /.mbr/mbr