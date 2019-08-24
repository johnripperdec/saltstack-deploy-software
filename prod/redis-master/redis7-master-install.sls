include:
  - redis.redis7-install
redis7-master-confile:
  file.managed:
    - name: /usr/local/redis/redis.conf
    - source: salt://redis-master/files/redis.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      REDIS_PORT: {{ pillar['redis']['redis_port1'] }}
    - require:
      - file: redis7-configdir
redis7-servicefile:
  file.managed:
    - name: /lib/systemd/system/redis.service
    - source: salt://redis-master/files/redis.service
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: redis
    - enable: True
    - require:
      - file: redis7-init
      - file: redis7-servicefile
    - watch:
      - file: redis7-master-confile


