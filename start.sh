#!/bin/bash

WWW_ROOT=/www/wwwroot

mkdir -p $WWW_ROOT
mkdir -p $WWW_ROOT/vhost/logs/
chown -R www:www $WWW_ROOT
chmod -R 777  $WWW_ROOT

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
