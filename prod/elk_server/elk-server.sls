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

