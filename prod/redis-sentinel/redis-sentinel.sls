include:
  - redis.redis-install
redis-sentinel-config:
  file.managed:
    - name: /usr/local/redis/redis_sentinel.conf
    - source: salt://redis-sentinel/files/sentinel_master.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      SENTINEL_PORT: {{ pillar['redis']['redis_sentinel_port'] }}
      SENTINEL_HOST: {{ pillar['redis']['redis_sentinelhost'] }}
      REDIS_PORT1: {{ pillar['redis']['redis_port1'] }}
      SENTINEL_NUM: {{ pillar['redis']['redis_sentinel_num'] }}
redis-init-config:
  file.managed:
    - name: /etc/init.d/redis-sentinel
    - source:  salt://redis-sentinel/files/redis-sentinel-init
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - defaults:
      REDISPORT: {{ pillar['redis']['redis_sentinel_port'] }}
  cmd.run:
    - name: chkconfig --add redis-sentinel
    - unless: chkconfig --list|grep redis-sentinel
    - require:
      - file: redis-sentinel-config
redis-sentinel-service:
  service.running:
    - name: redis-sentinel
    - enable: True
    - require:
      - file: redis-init-config
    - watch:
      - file: redis-sentinel-config

