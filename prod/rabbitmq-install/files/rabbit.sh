#!/bin/bash
cd /opt/soft
yum -y  localinstall erlang-19.0.4-1.el6.x86_64.rpm 
yum -y localinstall socat-1.7.2.3-1.el6.x86_64.rpm 
yum -y localinstall rabbitmq-server-3.6.10-1.el6.noarch.rpm
echo "start rabbitmq-server"
/etc/init.d/rabbitmq-server start
echo "create admin user"
rabbitmqctl add_user admin admin
echo "add admin user to administrator group"
rabbitmqctl set_user_tags admin administrator
echo "auth admin"
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
echo "enable plugins management"
rabbitmq-plugins enable rabbitmq_management
echo "modefy sysctl.conf"
echo "fs.file-max=65535">>/etc/sysctl.conf
sysctl -p
echo "modefy connection counter"
echo "ulimit -SHn 65535">>/etc/profile
source /etc/profile
echo "restart rabbitmq server"
/etc/init.d/rabbitmq-server stop
#/usr/sbin/rabbitmq-server  -detached
#echo "you can access from web http://ip:15672"
