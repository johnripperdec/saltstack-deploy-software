include:
  - elk_server.java-yum
kibana-rpm:
  file.managed:
    - name: /opt/kibana-5.1.2-x86_64.rpm
    - source: salt://elk_server/files/kibana-5.1.2-x86_64.rpm
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/kibana-5.1.2-x86_64.rpm
  cmd.run:
    - name: cd /opt && rpm -ivh kibana-5.1.2-x86_64.rpm
    - unless: test -d /etc/kibana
    - require:
      - file: kibana-rpm
kibana-config:
  file.managed:
    - name: /etc/kibana/kibana.yml
    - source: salt://elk_server/files/kibana/kibana.yml
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
      KIBANA_PORT: {{ pillar['elasticearch']['KIBANA_PORT'] }}
      KIBANA_HOST: {{ pillar['elasticearch']['KIBANA_HOST'] }}
      KIBANA_URL_HOST: {{ pillar['elasticearch']['HOST'] }}
      KIBANA_URL_PORT: {{ pillar['elasticearch']['ELASTICEARCH_PORT'] }}
    - require:
      - cmd: kibana-rpm
  service.running:
    - name: kibana
    - enable: True
    - require:
      - file: kibana-config
    - watch:
      - file: /etc/kibana/kibana.yml 
