keepalived7-install:
  file.managed:
    - name: /usr/local/src/keepalived-1.3.4.tar.gz
    - source: salt://keepalived/files/keepalived-1.3.4.tar.gz
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src && tar zxf keepalived-1.3.4.tar.gz && cd keepalived-1.3.4 && ./configure --prefix=/usr/local/keepalived --disable-fwmark && make && make install
    - unless: test -d /usr/local/keepalived
    - require:
      - file: keepalived7-install
keepalived-sysconfig:
  file.managed:
    - name: /etc/sysconfig/keepalived
    - source: salt://keepalived/files/keepalived.sysconfig
    - mode: 644
    - user: root
    - group: root
keepalived-initfile:
  file.managed:
    - name: /etc/init.d/keepalived
    - source: salt://keepalived/files/keepalived.init
    - mode: 755
    - user: root
    - group: root

keepalived-dic:
  file.directory:
    - name: /etc/keepalived
    - user: root
    - group: root
    - unless: test -d /etc/keepalived
