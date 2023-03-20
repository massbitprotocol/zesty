#!/bin/bash


supervisorctl stop all
rm /tmp/zesty/ -r
rm /usr/local/openresty -rf
rm /etc/supervisor/conf.d/openresty
rm /etc/supervisor/conf.d/openresty.conf
supervisorctl update
supervisorctl status