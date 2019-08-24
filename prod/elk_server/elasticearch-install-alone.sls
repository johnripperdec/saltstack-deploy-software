include:
  - elk_server.java-yum
elasticearch-rpm:
  file.managed:
    - name: /opt/elasticsearch-5.1.2.rpm
    - source: salt://elk_server/files/elasticsearch-5.1.2.rpm
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/elasticsearch-5.1.2.rpm
  cmd.run:
    - name: cd /opt && rpm -ivh elasticsearch-5.1.2.rpm
    - require:
      - file: elasticearch-rpm
    - unless: test -d /etc/elasticsearch
elasticearch-config:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://elk_server/files/elasticearch/elasticsearch.yml
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      NETWORK_HOST: {{ pillar['elasticearch']['HOST'] }}
      ELASTICEARCH_PORT: {{ pillar['elasticearch']['ELASTICEARCH_PORT'] }}
elasticearch-jvm:
  file.managed:
    - name: /etc/elasticsearch/jvm.options
    - source: salt://elk_server/files/elasticearch/jvm.options
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      XMX_lOG_CLIENT: {{ pillar['elasticearch']['XMX_lOG_CLIENT'] }}
elasticsearch-service:
  service.running:
    - name: elasticsearch
    - enable: True
    - watch:
      - file: /etc/elasticsearch/elasticsearch.yml
