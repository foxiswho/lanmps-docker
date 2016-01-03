
# Installation
Nginx:1.8.x

PHP:5.6.x

Pull the image from the docker index rather than downloading the git repo. This prevents you having to build the image on every docker host.

```
#拉取镜像
docker pull foxiswho/lanmps-docker:latest
```
# Running
To simply run the container:

```
sudo docker run --name lanmps -p 8080:80 -d foxiswho/lanmps-docker:latest
```

You can then browse to http://\<docker_host\>:8080 to view the default install files.
# Volumes
If you want to link to your web site directory on the docker host to the container run:

```
#创建容器
sudo docker run --name lanmps -p 8080:80 -v /your_code_directory:/www/wwwroot/default -d foxiswho/lanmps-docker:latest

sudo docker run --name lanmps -p 8080:80 -v /home/fox/www:/www/wwwroot/default -d foxiswho/lanmps-docker:latest
```

# BIN
```
#启动 容器
sudo docker start lanmps
#关闭 容器
sudo docker stop lanmps
#删除 容器
sudo docker rm lanmps
```

## Special Features

````
#进入容器内部
sudo docker exec -it <CONATINER_NAME> /bin/bash

sudo docker exec -it lanmps /bin/bash
````

##  ElasticSearch
```
https://hub.docker.com/_/elasticsearch/
拉取
sudo docker pull elasticsearch
运行
sudo docker run --name es -p 9200:9200 -p 9300:9300 -d elasticsearch:latest
```

##  Redis
```
https://hub.docker.com/_/redis/
拉取
docker pull redis
运行
docker run --name redis -p 6379:6379 -d redis:latest
```

##  Mysql
```
https://hub.docker.com/_/mysql/
拉取
docker pull mysql
运行(密码为root)
docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -d mysql:latest
```

#  Nginx + PHP + Mysql + Redis + ElasticSearch
```
#整合容器
sudo docker run --name lanmps --link mysql:db --link redis:redis --link es:es -p 80:80 -v /home/lanmps/www:/www/wwwroot/default -d foxiswho/lanmps-docker:latest
or
sudo docker run --name lanmps --link mysql:db -p 80:80 -v /home/lanmps/www:/www/wwwroot/default -d foxiswho/lanmps-docker:latest
```

## Windsow 下 通过虚拟机
```
```
## TOOL
```
#容器内装软件
apt-get install net-tools  ps vim-gtk ping
```

============================================================================================
一步步跟我做，搭建属于自己的 docker 开发环境
#1.docker 安装
##1.1 ubuntu 14.x 15.x
```
sudo apt-get update
curl -sSL https://get.docker.io/ | sudo sh
```
##1.2 centos 6.x 7.x
```
sudo yum update
curl -sSL https://get.docker.io/ | sudo sh
```
##1.3 如果安装出现错误
###1.3.1
```
FATA[0000] Error loading docker apparmor profile: fork/exec /sbin/apparmor_parser: no such file or directory () 
```
安装apparmor软件即可
```
sudo apt-get install apparmor  
```
下面需要创建用户和所属用户组，根据1.4 设置
```
Warning: The docker group is equivalent to the root user; For details on how this impacts security in your system, see Docker Daemon Attack Surface for details.
```
##1.4 设置用户和组

给 docker 设置用户组和用户
```
sudo useradd -g docker docker
sudo usermod -aG docker docker
```
#2.docker 启动
##2.1 启动
###2.1.1 旧启动方式
centos 6.x ,ubuntu 14.x
```
sudo service docker start
```
###2.1.2 新的启动方式
centos 7.x ,ubuntu 15.x
```
sudo systemctl start docker
```
##2.2 停止
```
#centos 7.x ,ubuntu 15.x
sudo systemctl stop docker
或
#centos 6.x ,ubuntu 14.x
sudo service docker stop
```
##2.3 重启
```
#centos 7.x ,ubuntu 15.x
sudo systemctl restart docker
或
#centos 6.x ,ubuntu 14.x
sudo service docker restart
```
##2.4 docker状态
```
#centos 7.x ,ubuntu 15.x
sudo systemctl status docker
或
#centos 6.x ,ubuntu 14.x
sudo service docker status
```
##2.5 docker 版本
```
sudo docker -v
```
#3 相关配置
配置文件增加参数
```
sudo vi /etc/default/docker 
```
在配置文件中添加或修改
```
DOCKER="/usr/bin/docker"
```
增加完成后，重启docker
```
sudo systemctl restart docker
```
#4 镜像拉取

> **注意：**
>如果拉取时间过长，docker hub 会自动切断链接，它会报超时错误！
>这个时候再重新执行拉取命令即可，他会接着上次拉取断的位置重新拉取的

##4.1 mysql
```
#来自 https://hub.docker.com/_/mysql/
sudo docker pull mysql:5.6
```
拉取时间根据每人的网速有关
项目都是根据 mysql 5.6 版本的，所以这里选择5.6版本
mysql:5.6 表示  镜像名称:版本号

##4.2 redis
```
#来自 https://hub.docker.com/_/redis/
sudo docker pull redis
```
redis 后面没有版本号时，默认拉取最新的一版 即  redis:latest
##4.3 ElasticSearch
```
#来自 https://hub.docker.com/_/elasticsearch/
sudo docker pull elasticsearch
```
elasticsearch 后面没有版本号时，默认拉取最新的一版 即  elasticsearch:latest

##4.4 nginx 和php
```
#来自 https://hub.docker.com/r/foxiswho/lanmps-docker
sudo docker pull foxiswho/lanmps-docker
```
lanmps 后面没有版本号时，默认拉取最新的一版 即  lanmps:latest
nginx 版本 1.8.0
php  版本 5.6.x


##4.5 memcached
有同学可能会使用这个缓存，需要的拿去
我们目前项目没有使用它
```
#来自 https://hub.docker.com/_/memcached/
sudo docker pull memcached
```
##4.x 镜像拉取相关问题
#### 4.x.1 拉取不成功
重新执行拉取命令
#### 4.x.2 哪种为拉取不成功
如下图：红色框内都是none 的表示拉取不成功，要重新执行拉取命令
![这里写图片描述](http://img.blog.csdn.net/20160103184652060)

#5 镜像查看
```
sudo docker images
```
#6 生成容器
##6.1 mysql
```
sudo docker run --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -d mysql:5.6
```
--name 容器名称
>mysql   为自定义名称

-p:暴露端口，映射端口(可以映射多个端口)          外部端口：容器内部端口
>-p 3306:3306   映射端口

-e:设置任意环境变量(容器内)
>MYSQL_ROOT_PASSWORD=root  这里指 设置数据库密码为root

mysql:5.6   镜像名称:版本
##6.2 redis
```
sudo docker run --name redis -p 6379:6379 -d redis:latest
```
redis   为自定义名称
-p 6379:6379   映射端口， 即  外部端口:容器内端口
redis:latest   镜像名称:版本

##6.3 ElasticSearch
```
sudo docker run --name es -p 9200:9200 -p 9300:9300 -d elasticsearch:latest
```
es   为自定义名称
-p 9200:9200   映射端口(可以映射多个端口)， 即  外部端口:容器内端口
elasticsearch:latest   镜像名称:版本
##6.4 Nginx+PHP
###6.4.1 方式一  容器内链接
```
docker run --name lanmps --link mysql:db --link es:es --link redis:redis -p 80:80 -v /home/lanmps/www:/www/wwwroot/default -d foxiswho/lanmps-docker
```
--name 容器名称

>--name lanmps   名为lanmps的容器

-p:暴露端口，映射端口(可以映射多个端口)          外部端口：容器内部端口
>-p 80:80   外部80端口:容器内部80端口

-d:后台模式运行，如果没有则以前台运行（当前进程关闭后，当前容器自动关闭）

foxiswho/lanmps-docker   镜像名称:版本

--link:容器内部通信          容器名称：内部别名（内部使用）
>--link mysql:db    使用时，直接使用db 就可以访问到数据库mysql容器
>php 访问本地mysql 使用的是localhost，容器内部即可使用 db

-v:卷，外部目录虚拟到容器内目录     外部目录：容器内目录
>-v /home/lanmps/www:/www/wwwroot/default
>    /home/lanmps/www 外部目录，我的项目目录
>    /www/wwwroot/default 容器内部目录，这个是不能改变的

**注意**
本地 目录设置权限和用户组
chown -R www:www /home/lanmps/www

chmod -R 777 /home/lanmps/www

这个时候访问本机 127.0.0.1:80  就可以看到 你的项目站点了


##6.4.2 方式二 使用IP端口连接

>**注意**
使用IP端口连接，必须是固定IP才可以


```
docker run --name lanmps -p 80:80 -v /home/lanmps/www:/www/wwwroot/default -d foxiswho/lanmps-docker
```
例如 本机ip 为 192.168.1.122
那么在链接   数据库3306 的时候，ip设置为192.168.1.122，端口号 3306

>**注意**
本地 目录设置权限和用户组
chown -R www:www /home/lanmps/www
chmod -R 777 /home/lanmps/www
这个时候访问本机 127.0.0.1:80  就可以看到 你的项目站点了

#7. 容器命令

> 普通情况下容器创建时，该容器就会是启动状态，如果关机了，那么就要启动该容器

##7.1 容器启动
先启动没有任何链接的容器，最后启动 有关联的容器
```
sudo docker start 容器名称

sudo docker start redis
sudo docker start mysql
sudo docker start es
sudo docker start lanmps
```
##7.2容器关闭
```
sudo docker stop 容器名称

sudo docker stop es
```
##7.3 容器重启
```
sudo docker restart 容器名称

sudo docker restart es
```
##7.4 容器状态
```
sudo docker status 容器名称
sudo docker status es
```
##7.5 容器删除
```
sudo docker rm 容器名称
```
删除所有容器
```
docker rm $(docker ps -q -a)
```
##7.6 进入容器内部
```
sudo docker exec -it lanmps /bin/bash
```
##7.7 查看 正在运行的容器
```
sudo docker ps
```
##7.8 查看 所有容器
```
sudo docker ps -a
```
#8 docker 镜像命令
##8.1 所有镜像
```
sudo docker images
```
##8.2 删除镜像
```
sudo docker rmi lanmps
```
删除所有镜像
```
docker rmi $(docker images -q) 
```
#9 docker 容器导入与导出

> 导出后再导入 的镜像会丢失所有的历史

##9.1 导出 export
>Export命令用于持久化容器（不是镜像）

```
#1.先查看 所有容器
sudo docker ps -a
#2.找到要导出容器 的 CONTAINER ID，然后执行命令
sudo docker export 容器CONTAINER ID > 导出地址文件名
即
sudo docker export 234wer2323dfdfdsfq > /home/export.tar
```
##9.2 导入 import
```
cat /home/export.tar | sudo docker import - lanmps:latest
```

#10 docker 镜像保存与加载

> 保存后再加载（saveed-loaded）的镜像没有丢失历史和层(layer)

##10.1 保存 save
>Save命令用于持久化镜像（不是容器）

```
#1.先查看 所有镜像
sudo docker images
#2.找到要保存的镜像名称
sudo docker save 镜像名称 > 保存地址文件名
即
sudo docker save lanmps > /home/save-lanmps.tar
```

##10.2 加载
```
docker load < /home/save-lanmps.tar
```
#11 访问项目站点
因为lanmps 设置的端口为80，那么就可以直接 在浏览器上 输入 127.0.0.1，
就可以看到 你的项目站点了