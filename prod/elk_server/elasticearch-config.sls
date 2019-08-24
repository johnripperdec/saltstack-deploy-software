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
