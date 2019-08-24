include:
  - nginx-fz.nginx-service
  - mysql.mysql-service
  - php.php-install
zabbix6-yum-sync:
  file.managed:
    - name: /opt/zabbix-release-3.4-1.el6.noarch.rpm
    - source: salt://zabbix3-4/files/zabbix-release-3.4-1.el6.noarch.rpm
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /opt && rpm -ivh  zabbix-release-3.4-1.el6.noarch.rpm
    - require:
      - file: zabbix6-yum-sync
    - unless: rpm -qa|grep zabbix-release-3.4-1.el6.noarch
zabbix6-pkg:
  pkg.installed:
    - names:
      - zabbix-server-mysql
      - zabbix-web-mysql
mysqld6-service:
  service.running:
    - name: mysqld
    - enable: True
modify_mysql6_password:
  file.managed:
    - name: /opt/my_passwd.sh
    - source: salt://zabbix3-4/files/my_passwd6.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - defaults:
      DB_PASSWORD: {{ pillar['zabbix']['db_password'] }}
    - unless: test -f /opt/my_passwd.sh
  cmd.run:
    - name: cd /opt && sh my_passwd.sh
create_zabbix6_database:
  file.managed:
    - name: /opt/create_zabbix_database.sh
    - source: salt://zabbix3-4/files/create_zabbix_database6.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - defaults:
      ZABBIX_PASSWORD: {{ pillar['zabbix']['zabbix_password'] }}
      DB_ROOT_PASS: {{ pillar['zabbix']['db_password'] }}
    - unless: test -f /opt/create_zabbix_database.sh
  cmd.run:
    - name: cd /opt && sh create_zabbix_database.sh
zabbix6_server_conf:
  file.managed:
    - name: /etc/zabbix/zabbix_server.conf
    - source: salt://zabbix3-4/files/zabbix_server.conf
    - user: root
    - group: zabbix
    - template: jinja
    - defaults:
      DB_PASS: {{ pillar['zabbix']['zabbix_password'] }}
dic_create:
  file.directory:
    - name: /var/www
    - user: root
    - group: root
    - mode: 731
    - unless: test -d /var/www
zabbix-web:
  file.managed:
    - name: /opt/zabbix-3.4.11.tar.gz
    - source: salt://zabbix3-4/files/zabbix-3.4.11.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /opt && tar -zxvf zabbix-3.4.11.tar.gz && cp -a zabbix-3.4.11/frontends/php/ /var/www/zabbix && chown -R www.www /var/www/zabbix
    - require:
      - file: zabbix-web
      - file: dic_create
    - unless: test -d /opt/zabbix-3.4.11
zabbix-nginx-conf:
  file.managed:
    - name: /usr/local/nginx/conf/vhost/zabbix-server.conf
    - source: salt://zabbix3-4/files/zabbix-nginx-server.conf
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: pkill -HUP nginx
    - require:
      - file: zabbix-nginx-conf
zabbix-service:
  service.running:
    - name: zabbix-server
    - enable: True
    - require:
      - cmd: create_zabbix6_database
