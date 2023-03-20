version: "3.8"
networks:
  mbr_test_network_99:
    driver: bridge
    external: true
services:
  mbr_zesty_99:
    privileged: true
    restart: unless-stopped
    image: massbit/massbitroute_zesty:[[ZESTY_TAG]]
    container_name: mbr_zesty_99
    networks:
      - mbr_test_network_99
    ports:
      - 5000:80
    volumes:
#        - ./volume/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf
#        - ./volume/modules.conf:/usr/local/openresty/nginx/conf/modules.conf
#        - ./volume/conf:/usr/local/openresty/nginx/conf/include:rw
#        - ./volume/conf/subconf:/usr/local/openresty/nginx/conf/subconf:rw
#        - ./volume/data:/usr/local/openresty/nginx/data:rw
#        - ./volume/logs:/usr/local/openresty/nginx/logs:rw
#        - ./volume/modules:/usr/local/openresty/nginx/extensions:rw
#        - ./volume/tmp:/usr/local/openresty/nginx/tmp:rw
#        - ./volume/scripts:/usr/local/openresty/lualib/mbr:rw
         - /massbit/test_runtime/99/zesty:/usr/local/openresty/nginx/logs
# # Minh testing working running conf
#        - ./volume/mbr:/.mbr:rw
    environment:
      - MBR_ENV=keiko
      - ID=
      - USER_ID=
      - BLOCKCHAIN=
      - NETWORK=
      - ZONE=
      - APP_KEY=
      - INSTALL_CMD=

    extra_hosts:
      - "hostmaster.massbitroute.net:172.24.99.254"
      - "ns1.massbitroute.net:172.24.99.254"
      - "ns2.massbitroute.net:172.24.99.254"
      - "api.massbitroute.net:172.24.99.254"
      - "stat.mbr.massbitroute.net:172.24.99.254"
      - "monitor.mbr.massbitroute.net:172.24.99.254"
      - "chain.massbitroute.net:172.24.99.254"
      - "portal.massbitroute.net:172.24.99.254"
      - "portal-beta.massbitroute.net:172.24.99.254"
      - "admin-beta.massbitroute.net:172.24.99.254"
      - "dapi.massbitroute.net:172.24.99.254"
      - "api.ipapi.com:172.24.99.254"
      - "staking.massbitroute.net:172.24.99.254"
      - "git.massbitroute.net:172.24.99.5"
      - "fairy.massbitroute.net:172.24.99.3"
      - "ipv4.icanhazip.com:172.24.99.254"
