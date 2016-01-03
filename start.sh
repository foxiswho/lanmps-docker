#!/bin/bash


mkdir -p /www/wwwroot/default/logs
ln -s /www/wwwLogs/* /www/wwwroot/default/logs/
# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
