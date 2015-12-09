FROM centos:latest

MAINTAINER foxWho <foxiswho@gmail.com>

RUN yum makecache && yum install wget -y
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
RUN cd /etc/yum.repos.d/ && wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -O CentOS-Base.repo
RUN yum clean all && yum makecache
EXPOSE 80

CMD ["/bin/bash"]
