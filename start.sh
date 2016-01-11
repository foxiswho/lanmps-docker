#!/bin/bash


if [ -f /www/wwwroot/vhost/more.yes ]; then

else
    mkdir -p /www/wwwroot/default/logs
    ln -s /www/wwwLogs/localhost.log /www/wwwroot/default/logs/localhost.log
    ln -s /www/wwwLogs/nginx_error.log /www/wwwroot/default/logs/nginx_error.log
    ln -s /www/wwwLogs/php-fpm.log /www/wwwroot/default/logs/php-fpm.log
fi


# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
