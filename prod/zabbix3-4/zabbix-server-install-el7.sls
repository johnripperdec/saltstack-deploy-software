zabbix-yum-sync:
  file.managed:
    - name: /opt/zabbix-release-3.4-2.el7.noarch.rpm
    - source: salt://zabbix3-4/files/zabbix-release-3.4-2.el7.noarch.rpm
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /opt && rpm -ivh zabbix-release-3.4-2.el7.noarch.rpm
    - require:
      - file: zabbix-yum-sync
zabbix-pkg:
  pkg.installed:
    - names:
      - zabbix-server-mysql
      - zabbix-web-mysql
      - mariadb-server
      - mariadb
  service.running:
    - name: mariadb
    - enable: True
    - reuqire:
      - pkg: zabbix-pkg
modify_mysql_password:
  file.managed:
    - name: /opt/my_passwd.sh
    - source: salt://zabbix3-4/files/my_passwd.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - defaults:
      DB_PASSWORD: {{ pillar['zabbix']['db_password'] }}
    - unless: test -f /opt/my_passwd.sh
  cmd.run:
    - name: cd /opt && sh my_passwd.sh
create_zabbix_database:
  file.managed:
    - name: /opt/create_zabbix_database.sh
    - source: salt://zabbix3-4/files/create_zabbix_database.sh
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
zabbix_server_conf:
  file.managed:
    - name: /etc/zabbix/zabbix_server.conf
    - source: salt://zabbix3-4/files/zabbix_server.conf
    - user: root
    - group: zabbix
    - template: jinja
    - defaults:
      DB_PASS: {{ pillar['zabbix']['zabbix_password'] }}
zabbix_http_conf:
  file.managed:
    - name: /etc/httpd/conf.d/zabbix.conf
    - source: salt://zabbix3-4/files/zabbix.conf
    - user: root
    - group: root
    - mode: 644
zabbix-service:
  service.running:
    - name: zabbix-server
    - enable: True
    - require:
      - cmd: create_zabbix_database
httpd-service:
  service.running:
    - name: httpd
    - enable: True
