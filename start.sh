#!/bin/bash

# Disable Strict Host checking for non interactive git clones



mkdir -p /www/wwwroot/default/logs
ln -s /www/wwwLogs/* /www/wwwroot/default/logs/
# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
