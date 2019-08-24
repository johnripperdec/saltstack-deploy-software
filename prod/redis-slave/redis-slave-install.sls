include:
  - redis.redis-install
redis-slave-confile:
  file.managed:
    - name: /usr/local/redis/redis.conf
    - source: salt://redis-slave/files/redis_slave.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      REDIS_PORT: {{ pillar['redis']['redis_port1'] }}
      SLAVE_HOST: {{pillar['redis']['redis_sentinelhost']}}
    - require:
      - file: redis-configdir
  service.running:
    - name: redis
    - enable: True
    - require:
      - file: redis-init
    - watch:
      - file: redis-slave-confile


