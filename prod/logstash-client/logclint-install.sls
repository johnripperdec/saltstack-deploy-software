include:
  - elk_server.java-yum
logstashcli-rpm:
  file.managed:
    - name: /opt/logstash-5.1.2.rpm
    - source: salt://logstash-client/files/logstash-5.1.2.rpm
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/logstash-5.1.2.rpm
  cmd.run:
    - name: cd /opt && rpm -ivh logstash-5.1.2.rpm
    - unless: test -d /etc/logstash
    - require:
      - file: logstashcli-rpm
logstash-cli-config:
  file.managed:
    - name: /etc/logstash/conf.d/logstash_nginx.conf
    - source: salt://logstash-client/files/logstash/logstash_nginx.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaulats:
      REDIS_PORT: {{ pillar['elasticearch']['REDIS_PORT'] }}
      REDIS_HOST: {{ pillar['elasticearch']['REDIS_HOST'] }}
      HOSTS: {{ pillar['elasticearch']['HOST'] }}
    - require:
      - cmd: logstashcli-rpm
logstash-cli-jvm:
  file.managed:
    - name: /etc/logstash/jvm.options
    - source: salt://logstash-client/files/logstash/jvm.options
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      XMS_LOG_CLIENT: {{ pillar['elasticearch']['XMS_LOG_CLIENT'] }}
      XMX_lOG_CLIENT: {{ pillar['elasticearch']['XMX_lOG_CLIENT'] }}
logstash-cli-service:
  service.running:
    - name: logstash
    - enable: True
    - require:
      - file: logstash-cli-config
    - watch:
      - file: /etc/logstash/conf.d/*.conf
