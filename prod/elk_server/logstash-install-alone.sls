include:
  - elk_server.java-yum
logstash-rpm:
  file.managed:
    - name: /opt/logstash-5.1.2.rpm
    - source: salt://elk_server/files/logstash-5.1.2.rpm
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/logstash-5.1.2.rpm
  cmd.run:
    - name: cd /opt && rpm -ivh logstash-5.1.2.rpm
    - unless: test -d /etc/logstash
    - require:
      - file: logstash-rpm
logstash-ser-config:
  file.managed:
    - name: /etc/logstash/conf.d/log_ser.conf
    - source: salt://elk_server/files/logstash/log_ser.conf_server
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaulats:
      REDIS_PORT: {{ pillar['elasticearch']['REDIS_PORT'] }}
      REDIS_HOST: {{ pillar['elasticearch']['REDIS_HOST'] }}
      HOSTS: {{ pillar['elasticearch']['HOST'] }}
    - require:
      - cmd: logstash-rpm
logstasg-input-redis:
  file.managed:
    - name: /etc/logstash/conf.d/inpuet_redis.conf
    - source: salt://elk_server/files/logstash/inpuet_redis.conf
    - user: root
    - group: root
    - mode: 644
logstash-jvm:
  file.managed:
    - name: /etc/logstash/jvm.options
    - source: salt://elk_server/files/logstash/jvm.options
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      XMS_LOG_CLIENT: {{ pillar['elasticearch']['XMS_LOG_CLIENT'] }}
      XMX_lOG_CLIENT: {{ pillar['elasticearch']['XMX_lOG_CLIENT'] }}
logstash-service:
  service.running:
    - name: logstash
    - enable: True
    - require:
      - file: logstash-ser-config
    - watch:
      - file: /etc/logstash/conf.d/*.conf
