#!/bin/bash

WWW_ROOT=/www/wwwroot

mkdir -p $WWW_ROOT
mkdir -p $WWW_ROOT/vhost/logs/
chown -R www:www $WWW_ROOT
chmod -R 777  $WWW_ROOT

#当前时间
DATETIME=$(date +%Y-%m-%d-%H-%M-%S)
mkdir -p $WWW_ROOT/vhost/logs/$DATETIME
#每次启动清除日志文件，防止启动出错
mv $WWW_ROOT/vhost/logs/* $WWW_ROOT/vhost/logs/$DATETIME/

touch $WWW_ROOT/vhost/logs/index.log
echo " START ==================================\n" >> $WWW_ROOT/vhost/logs/supervisord.log

CONF=$WWW_ROOT/vhost/00000.default.conf
if [ ! -f $CONF ]; then
    cp -auvR /www/lanmps/nginx/conf/vhost/00000.default.conf $WWW_ROOT/vhost/
fi
INDEX=$WWW_ROOT/index.php
if [ ! -f $INDEX ]; then
    echo "<?php phpinfo();" > $INDEX
fi

/etc/init.d/supervisor start

echo "OK"
