mysql-yum:
  file.managed:
    - name: /opt/mysql-community-release-el7-5.noarch.rpm
    - source: salt://mysql_yum/files/mysql-community-release-el7-5.noarch.rpm
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /opt && rpm -ivh mysql-community-release-el7-5.noarch.rpm
    - unless: yum list |grep mysql-community-devel
    - require:
      - file: mysql-yum
