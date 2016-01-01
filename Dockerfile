FROM debian:jessie


ENV PHP_DIR /www/lanmps/php
ENV IN_DIR /www/lanmps
ENV IN_WEB_DIR /www/wwwroot
ENV IN_WEB_LOG_DIR /www/wwwLogs

RUN rm -rf /etc/localtime && \
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    groupadd www && \
    useradd -s /sbin/nologin -g www www && \
    mkdir -p $PHP_DIR && \
    mkdir -p $IN_WEB_DIR/wwwLogs && \
    mkdir -p $IN_WEB_DIR/vhost && \
    ln -s $IN_WEB_DIR/wwwLogs /www/ && \
    mkdir -p $IN_DIR/etc  && \
    mkdir -p $IN_DIR/init.d  && \
    mkdir -p $IN_DIR/action  && \
    mkdir -p $IN_DIR/run  && \
    mkdir -p $IN_WEB_DIR/default && \
    chmod +w $IN_WEB_DIR/default && \
#    mkdir -p $IN_WEB_LOG_DIR && \
    chmod 777 $IN_WEB_LOG_DIR && \
    chown -R www:www $IN_WEB_DIR/default && \
    mkdir -p ${PHP_DIR}/etc/ && \
    mkdir -p ${PHP_DIR}/conf.d/


# Supervisor Config
ADD conf/supervisord.conf /etc/supervisord.conf
# Start Supervisord
ADD ./start.sh /start.sh
# add test PHP file
ADD ./conf/index.php $IN_WEB_DIR/default/
ADD ./conf/action.nginx $IN_DIR/action/nginx

RUN chmod +x /start.sh && \
     chmod +x $IN_DIR/action/nginx && \
     chown -R www:www $IN_WEB_DIR/  && \
     chmod -R 777 $IN_WEB_DIR/default
     
     
# persistent / runtime deps
#RUN sed -i 's#http://httpredir.debian.org/debian#http://mirrors.163.com/debian#g' /etc/apt/sources.list && \
#    apt-get update && \
#    sed -i 's#http://httpredir.debian.org/debian#http://mirrors.163.com/debian#g' /etc/apt/sources.list && \
#    sed -i 's#http://security.debian.org/debian#http://mirrors.163.com/debian-security#g' /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y \
    ca-certificates \
    curl librecode0 \
    libsqlite3-0 \
    libxml2  \
    autoconf \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkg-config \
    unzip \
    supervisor \
#    wget \
    libpcre3 libpcre3-dev openssl libssl-dev zlibc zlib1g zlib1g-dev mcrypt libmcrypt-dev \
    libssl-dev \
    libxml2-dev \
    libjpeg-dev \
    libpng12-dev \
    libfreetype6-dev \
    libxpm-dev \
    php5-curl \
    libmhash2 \
    libmhash-dev \
    flex \
    php5-gd \
    libcurl4-openssl-dev \
    re2c --no-install-recommends

#NGINX
ADD down/nginx-1.8.0.tar.gz /tmp/
#RUN [ ! -d "/tmp/nginx-1.8.0" ] && curl -fSL http://download.lanmps.com/nginx/nginx-1.8.0.tar.gz -o nginx-1.8.0.tar.gz && tar -zxf nginx-1.8.0.tar.gz
RUN cd /tmp/nginx-1.8.0/ && \
	./configure \
	--user=www \
	--group=www \
	--prefix=$IN_DIR/nginx \
	--with-http_stub_status_module \
	--with-http_ssl_module \
	--with-http_gzip_static_module \
	--with-ipv6 \
	#--http-proxy-temp-path=${IN_DIR}/tmp/nginx-proxy \
	#--http-fastcgi-temp-path=${IN_DIR}/tmp/nginx-fcgi \
	#--http-uwsgi-temp-path=${IN_DIR}/tmp/nginx-uwsgi \
	#--http-scgi-temp-path=${IN_DIR}/tmp/nginx-scgi \
	#--http-client-body-temp-path=${IN_DIR}/tmp/nginx-client \
	--http-log-path=${IN_WEB_LOG_DIR}/nginx.log \
	--error-log-path=${IN_WEB_LOG_DIR}/nginx-error.log && \
	make && make install && \
	ln -s $IN_DIR/nginx/sbin/nginx /usr/bin/nginx && \
	mkdir -p $IN_WEB_DIR/vhost

COPY conf/nginx.conf $IN_DIR/nginx/conf/nginx.conf
COPY conf/fastcgi.conf $IN_DIR/nginx/conf/fastcgi.conf
COPY conf/upstream.conf $IN_DIR/nginx/conf/upstream.conf
COPY conf/default.conf $IN_WEB_DIR/vhost/00000.default.conf


ENV GPG_KEYS 0BD78B5F97500D450838F95DFE857D9A90D90EC1 6E4F6AB321FDC07F2C332E3AC2BF0BC433CFC8B3
RUN set -xe  && \
	for key in $GPG_KEYS; do \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done

ENV PHP_VERSION 5.6.16
ENV PHP_FILENAME php-5.6.16.tar.xz
ENV PHP_SHA256 8ef43271d9bd8cc8f8d407d3ba569de9fa14a28985ae97c76085bb50d597de98

# --enable-mysqlnd is included below because it's harder to compile after the fact the extensions are (since it's a plugin for several extensions, not an extension in itself)
RUN buildDeps=" \
		$PHP_EXTRA_BUILD_DEPS \
		libreadline6-dev \
		librecode-dev \
		libsqlite3-dev \
		xz-utils \
	"  && \
	set -x  && \
	apt-get install -y $buildDeps --no-install-recommends  && \
	curl -fSL "http://php.net/get/$PHP_FILENAME/from/this/mirror" -o "$PHP_FILENAME"  && \
	echo "$PHP_SHA256 *$PHP_FILENAME" | sha256sum -c -  && \
	curl -fSL "http://php.net/get/$PHP_FILENAME.asc/from/this/mirror" -o "$PHP_FILENAME.asc"  && \
	gpg --verify "$PHP_FILENAME.asc"  && \
	mkdir -p /tmp/php  && \
	tar -xf "$PHP_FILENAME" -C /tmp/php --strip-components=1  && \
	rm "$PHP_FILENAME"*  && \
	cd /tmp/php  && \
	 ./configure --prefix="$PHP_DIR" \
		--with-config-file-path="$PHP_DIR" \
		--with-config-file-scan-dir="$PHP_DIR/conf.d" \
		--with-mysql=mysqlnd \
        --with-mysqli=mysqlnd \
        --with-pdo-mysql=mysqlnd \
        --with-freetype-dir \
        --with-jpeg-dir \
        --with-png-dir \
        --with-zlib \
        --with-libxml-dir=/usr \
        --with-curl \
        --with-openssl \
        --with-readline \
        --with-recode \
        --with-mcrypt \
        --with-gd \
        --with-openssl \
        --with-mhash \
        --with-xmlrpc \
        --without-pear \
        --with-gettext \
        --with-fpm-user=www \
        --with-fpm-group=www \
        --enable-fpm \
		--disable-cgi \
		--enable-mysqlnd \
        --enable-xml \
        --enable-opcache \
        --disable-rpath \
        --enable-bcmath \
        --enable-shmop \
        --enable-sysvsem \
        --enable-inline-optimization \
        --enable-mbregex \
        --enable-mbstring \
        --enable-ftp \
        --enable-gd-native-ttf \
        --enable-pcntl \
        --enable-sockets \
        --enable-zip \
        --enable-soap \
        --disable-fileinfo && \
	make -j"$(nproc)" && \
	make install  && \
	{ find /usr/local/bin /usr/local/sbin -type f -executable -exec strip --strip-all '{}' + || true; }  && \
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false $buildDeps  && \
	make clean
#相关软连接
RUN ln -s "${PHP_DIR}/bin/php" /usr/bin/php && \
    ln -s "${PHP_DIR}/bin/phpize" /usr/bin/phpize && \
    ln -s "${PHP_DIR}/sbin/php-fpm" /usr/bin/php-fpm && \
    cp /tmp/php/sapi/fpm/init.d.php-fpm $IN_DIR/action/php-fpm && \
    chmod +x $IN_DIR/action/php-fpm && \
    cd ${PHP_DIR}/etc && \
    mv php-fpm.conf.default php-fpm.conf && \
    cp /tmp/php/php.ini-production $PHP_DIR/php.ini
# PHP 配置文件
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" ${PHP_DIR}/php.ini && \
sed -i -e "s/;date.timezone\s*=/date.timezone = PRC/g" ${PHP_DIR}/php.ini && \
sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" ${PHP_DIR}/php.ini && \
sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" ${PHP_DIR}/php.ini && \
sed -i -e "s/max_execution_time\s*=\s*30/max_execution_time = 300/g" ${PHP_DIR}/php.ini && \
sed -i -e 's/short_open_tag = Off/short_open_tag = On/g' ${PHP_DIR}/php.ini && \
sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHP_DIR}/php.ini && \
sed -i -e 's/;cgi.fix_pathinfo=0/cgi.fix_pathinfo=0/g' ${PHP_DIR}/php.ini && \
sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHP_DIR}/php.ini && \
sed -i -e 's/register_long_arrays = On/;register_long_arrays = On/g' ${PHP_DIR}/php.ini && \
sed -i -e 's/magic_quotes_gpc = On/;magic_quotes_gpc = On/g' ${PHP_DIR}/php.ini && \
#sed -i -e 's/disable_functions =.*/disable_functions = passthru,exec,system,chroot,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server/g' ${PHP_DIR}/php.ini && \
#sed -i -e 's:mysql.default_socket =:mysql.default_socket ='$IN_DIR'/mysql/data/mysql.sock:g' ${PHP_DIR}/php.ini && \
#sed -i -e 's:pdo_mysql.default_socket.*:pdo_mysql.default_socket ='$IN_DIR'/mysql/data/mysql.sock:g' ${PHP_DIR}/php.ini && \
sed -i -e 's/expose_php = On/expose_php = Off/g' ${PHP_DIR}/php.ini && \
#sed -i 's#\[opcache\]#\[opcache\]\nzend_extension=opcache.so#g' ${PHP_DIR}/php.ini && \
sed -i -e "s#;\s*expose_php#expose_php#g" ${PHP_DIR}/php.ini && \
sed -i -e 's#extension_dir = "./"#extension_dir = "'$IN_DIR'/php/lib/php/extensions/no-debug-non-zts-20131226/"\nextension = memcache.so\nextension =redis.so\nzend_extension =opcache.so\n#' ${PHP_DIR}/php.ini

# php-fpm 配置文件
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" ${PHP_DIR}/etc/php-fpm.conf  && \
sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" ${PHP_DIR}/etc/php-fpm.conf && \
sed -i 's:;pid = run/php-fpm.pid:pid = run/php-fpm.pid:g' ${PHP_DIR}/etc/php-fpm.conf && \
sed -i 's:;error_log = log/php-fpm.log:error_log = '"$IN_WEB_LOG_DIR"'/php-fpm.log:g' ${PHP_DIR}/etc/php-fpm.conf && \
sed -i 's:;log_level = notice:log_level = notice:g' ${PHP_DIR}/etc/php-fpm.conf && \
sed -i 's:pm.max_children = 5:pm.max_children = 10:g' ${PHP_DIR}/etc/php-fpm.conf && \
sed -i 's:pm.start_servers = 2:pm.start_servers = 3:g' ${PHP_DIR}/etc/php-fpm.conf && \
sed -i 's:pm.max_spare_servers = 3:pm.max_spare_servers = 6:g' ${PHP_DIR}/etc/php-fpm.conf && \
sed -i 's:;request_terminate_timeout = 0:request_terminate_timeout = 100:g' ${PHP_DIR}/etc/php-fpm.conf && \
sed -i 's/127.0.0.1:9000/127.0.0.1:9950/g' ${PHP_DIR}/etc/php-fpm.conf

#memcache
ADD down/memcache-3.0.8.tgz /tmp/
#RUN [ ! -d "/tmp/memcache-3.0.8" ] && curl -fSL http://download.lanmps.com/memcache/memcache-3.0.8.tar.gz -o memcache-3.0.8.tar.gz && tar -zxf memcache-3.0.8.tar.gz
RUN cd /tmp/memcache-3.0.8/ && \
	${PHP_DIR}/bin/phpize && \
	./configure --enable-memcache --with-php-config=${PHP_DIR}/bin/php-config --with-zlib-dir  && \
	make && make install
#redis
RUN cd /tmp/  && \
	#if [ ! -f "/tmp/phpredis-master.zip" ]; then \
	    curl -fSL https://github.com/nicolasff/phpredis/archive/master.zip -o phpredis-master.zip && \
	    #wget https://github.com/nicolasff/phpredis/archive/master.zip -O phpredis-master.zip \
	#fi  && \
	unzip phpredis-master.zip  && \
	cd phpredis-master  && \
	${PHP_DIR}/bin/phpize && \
	./configure --with-php-config=${PHP_DIR}/bin/php-config && \
	make && make install


#删除多余文件
RUN apt-get clean && \
apt-get autoclean && \
rm -rf /root/lanmps-* && \
rm -rf /tmp/* && \
rm -rf /var/log/yum.log && \
rm -rf /var/cache/yum/* && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/man/?? && \
rm -rf /usr/share/man/??_*

##<autogenerated>##
WORKDIR $IN_WEB_DIR/default
# Setup Volume
VOLUME [$IN_WEB_DIR]

# Expose Ports
EXPOSE 443
EXPOSE 80

CMD ["/bin/bash", "/start.sh"]
