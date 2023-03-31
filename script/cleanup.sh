#!/bin/bash


supervisorctl stop all
rm /tmp/zesty/ -r
rm /usr/local/openresty -rf
rm /etc/supervisor/conf.d/openresty
rm /etc/supervisor/conf.d/openresty.conf
supervisorctl update
supervisorctl status
kill $(ps aux | grep '[n]ginx' | awk '{print $2}')
rm /tmp/mbr_datasources.sock
rm /.mbr
rm /usr/bin/mbr > /dev/null
echo "" | crontab
