mysql-server-pkg:
  pkg.installed:
    - name: mysql-community-server
    - unless: rpm -qa|grep mysql-community-server
mysql-config:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://mysql_yum/files/my.cnf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: mysql-server-pkg
mysql-service-file:
  file.managed:
    - name: /lib/systemd/system/mysqld.service
    - source: salt://mysql_yum/files/mysqld.service
    - user: root
    - group: root
    - mode: 644
mysqld-servic:
  service.running:
    - name: mysqld
    - enable: True
    - require:
      - file: mysql-service-file
