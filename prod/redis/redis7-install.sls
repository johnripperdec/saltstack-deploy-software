redis7-sorce:
  file.managed:
    - name: /opt/redis-4.0.6.tar.gz
    - source: salt://redis/files/redis-4.0.6.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /opt && tar zxf redis-4.0.6.tar.gz && cd redis-4.0.6 && make && make install
    - unless: test -f /usr/local/bin/redis-server
    - require:
      - pkg: pkg-install
      - file: redis7-sorce
redis7-configdir:
  file.directory:
    - name: /usr/local/redis
    - user: root
    - group: root
    - unless: test -d /usr/local/redis

redis7-init:
  file.managed:
    - name: /etc/init.d/redis
    - source: salt://redis/files/redis-init
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - default:
      INIT_PORT: {{ pillar['redis']['redis_port1'] }}
  cmd.run:
    - name: chkconfig --add redis
    - unless: chkconfig --list|grep redis
    - require:
      - file: redis7-init


