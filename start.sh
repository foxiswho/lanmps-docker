#!/bin/bash


#if [ -f /www/wwwroot/vhost/more.yes ]; then
#   rm -rf /www/wwwroot/wwwLogs
#   ln -s /www/wwwroot/wwwLogs /www/
#else
#    mkdir -p /www/wwwroot/default/logs
#    ln -s /www/wwwroot/wwwLogs/localhost.log /www/wwwroot/default/logs/localhost.log
#    ln -s /www/wwwroot/wwwLogs/nginx_error.log /www/wwwroot/default/logs/nginx_error.log
#    ln -s /www/wwwroot/wwwLogs/php-fpm.log /www/wwwroot/default/logs/php-fpm.log
#    ln -s /www/wwwroot/wwwLogs/supervisord.log /www/wwwroot/default/logs/supervisord.log
#    ln -s /www/wwwroot/wwwLogs /www/wwwroot/default/logs
#fi
#关闭 防止重复启动
#/www/lanmps/action/php-fpm stop
#/www/lanmps/action/nginx stop

# Start supervisord and services
#/usr/bin/supervisord -n -c /etc/supervisord.conf


sed -i -e "s#\[supervisord\]#\[supervisord\]\nnodaemon=true\nuser=root#" /etc/supervisor/supervisord.conf

#/etc/init.d/supervisor
/etc/init.d/supervisor start

echo "OK"
