#!/bin/bash
/usr/local/mysql/bin/mysql -uroot -p{{DB_ROOT_PASS}} -e 'create database zabbix character set utf8 collate utf8_bin;'
/usr/local/mysql/bin/mysql -uroot -p{{DB_ROOT_PASS}} -e "use zabbix;grant all privileges on zabbix.* to zabbix@localhost identified by '{{ZABBIX_PASSWORD}}';"
/usr/local/mysql/bin/mysql -uroot -p{{DB_ROOT_PASS}} -e "use zabbix;grant all privileges on zabbix.* to zabbix@'%' identified by '{{ZABBIX_PASSWORD}}';"
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | /usr/local/mysql/bin/mysql -uzabbix -p{{ZABBIX_PASSWORD}} zabbix
