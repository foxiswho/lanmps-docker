#!/bin/bash

mkdir -p /www/wwwroot/default/logs
chown -R www:www /www/wwwroot/default/logs
chmod -R 777  /www/wwwroot/default/logs
echo " START ==================================\n" >> /www/wwwroot/default/logs/supervisord.log

/etc/init.d/supervisor start

echo "OK"
