include:
  - user.mysql
boost-dic:
  file.dircetory:
    - name: /usr/local/boost
    - unless: test -d /usr/local/boost
boost-file:
  file.managed:
    - name: /usr/local/boost/boost_1_59_0.tar.gz
    - source: salt://mysql/files/boost_1_59_0.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /usr/local/boost/boost_1_59_0.tar.gz
  cmd.run:
    - name: cd /usr/local/boost/ && tar zxf boost_1_59_0.tar.gz
    - unless: test -d boost_1_59_0
mysql-source:
  file.managed:
    - name: /opt/mysql-5.7.27.tar.gz
    - source: salt://mysql/files/mysql-5.7.27.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /opt && tar zxf mysql-5.7.27.tar.gz && cd mysql-5.7.27 && cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci  -DWITH_BOOST=/usr/local/boost -DWITH_READLINE=1 -DWITH_SSL=system -DWITH_ZLIB=system -DWITH_EMBEDDED_SERVER=1 -DENABLED_LOCAL_INFILE=1  && make && make install && chown -R mysql.mysql /usr/local/mysql 
    - unless: test -d /usr/local/mysql
    - require:
      - file: mysql-source
      - user: mysql-user-group
mysql-cnf:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://mysql/files/my.cnf
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /etc/my.cnf
  cmd.run:
    - name: /usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --user=mysql --defaults-file=/etc/my.cnf
    - unless: test -d /usr/local/mysql/data/mysql
    - require:
      - cmd: mysql-source
