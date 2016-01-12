#!/bin/bash


if [ ! -f /www/wwwroot/vhost/more.yes ]; then
    mkdir -p /www/wwwroot/default/logs
    ln -s /www/wwwroot/wwwLogs/localhost.log /www/wwwroot/default/logs/localhost.log
    ln -s /www/wwwroot/wwwLogs/nginx_error.log /www/wwwroot/default/logs/nginx_error.log
    ln -s /www/wwwroot/wwwLogs/php-fpm.log /www/wwwroot/default/logs/php-fpm.log
fi


# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
