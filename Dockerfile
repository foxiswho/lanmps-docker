FROM centos:latest

MAINTAINER foxWho <foxiswho@gmail.com>
#生成缓存 安装wget
RUN yum makecache && yum install wget -y
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
RUN cd /etc/yum.repos.d/ && wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -O CentOS-Base.repo
#清除缓存 生成缓存
RUN yum clean all && yum makecache
#时区
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

EXPOSE 80

CMD ["/bin/bash"]
