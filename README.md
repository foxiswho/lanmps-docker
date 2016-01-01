
# Installation
Nginx:1.8.x
PHP:5.6.x
Pull the image from the docker index rather than downloading the git repo. This prevents you having to build the image on every docker host.

```
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
sudo docker run --name lanmps -p 8080:80 -v /your_code_directory:/www/wwwroot/default -d foxiswho/lanmps-docker:latest

sudo docker run --name lanmps -p 8080:80 -v /home/fox/www:/www/wwwroot/default -d foxiswho/lanmps-docker:latest
```

## Special Features

````
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
sudo docker run --name lanmps --link mysql:db --link redis:redis --link es:es -p 80:80 -v /home/lanmps/www:/www/wwwroot/default -d foxiswho/lanmps-docker:latest
or
sudo docker run --name lanmps --link mysql:db -p 80:80 -v /home/lanmps/www:/www/wwwroot/default -d foxiswho/lanmps-docker:latest
```

## Windsow 下 通过虚拟机
```
```
## TOOL
```
apt-get install net-tools  ps vim ping
```
