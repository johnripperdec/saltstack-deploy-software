include:
  - redis.redis-install
redis-master-confile:
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
      - file: redis-configdir
redis-servicefile:
  service.running:
    - name: redis
    - enable: True
    - require:
      - file: redis-init
    - watch:
      - file: redis-master-confile


