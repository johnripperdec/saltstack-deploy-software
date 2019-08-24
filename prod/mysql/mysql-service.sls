include:
  - mysql.mysql-install
mysql-mcf:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://mysql/files/my.cnf
    - user: root
    - group: root
    - mode: 644
mysql-comand:
  file.append:
    - name: /root/.bash_profile 
    - text:
      - export PATH=$PATH:$HOME/bin:/usr/local/mysql/bin
  cmd.run:
    - name: source /root/.bash_profile 
    - require:
      - file: mysql-comand
mysql-service:
  file.managed:
    - name: /etc/init.d/mysqld
    - source: salt://mysql/files/mysqld
    - user: root
    - group: root
    - mode: 755
    - unless: test -f /etc/init.d/mysqld
  cmd.run:
    - name: chkconfig --add mysqld
    - unless: chkconfig --list|grep mysqld
  service.running:
    - name: mysqld
    - enable: True
    - require:
      - file: mysql-service
    - watch:
      - file: mysql-mcf
    
