FROM centos:latest

MAINTAINER foxWho <foxiswho@gmail.com>
#生成缓存 安装wget
RUN yum makecache 
RUN yum install wget -y
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
RUN cd /etc/yum.repos.d/ && wget http://mirrors.163.com/.help/CentOS7-Base-163.repo -O CentOS-Base.repo
#清除缓存 生成缓存
RUN yum clean all && yum makecache
#时区
RUN rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN cd /root/ && wget http://download.lanmps.com/lanmps/lanmps-3.0.1.tar.gz -O lanmps-3.0.1.tar.gz && tar zxvf lanmps-3.0.1.tar.gz && cd lanmps-3.0.1 && ./docker.sh
#ADD ./lanmps-3.0.1.tar.gz /root/
#清空缓存
RUN yum clean all
#删除多余文件
RUN rm -rf /root/lanmps-* && \
rm -rf /tmp/* && \
rm -rf /var/log/yum.log && \
rm -rf /var/cache/yum/* && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /usr/share/man/?? && \
rm -rf /usr/share/man/??_*


EXPOSE 80

CMD ["/bin/bash"]
