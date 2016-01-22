#!/bin/bash

WWW_ROOT=/www/wwwroot

mkdir -p $WWW_ROOT/default
mkdir -p $WWW_ROOT/vhost/logs/
chown -R www:www $WWW_ROOT/default
chmod -R 777  $WWW_ROOT/default

touch $WWW_ROOT/vhost/logs/index.log
echo " START ==================================\n" >> $WWW_ROOT/vhost/logs/supervisord.log

CONF=/www/lanmps/nginx/conf/vhost/00000.default.conf
if [ ! -f $CONF ]; then
    cp -auvR $CONF $WWW_ROOT/vhost/
fi


/etc/init.d/supervisor start

echo "OK"
