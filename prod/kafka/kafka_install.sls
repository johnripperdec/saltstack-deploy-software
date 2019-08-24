kafka_file:
  file.managed:
    - name: /opt/kafka_2.12-2.3.0.tgz
    - source: salt://kafka/files/kafka_2.12-2.3.0.tgz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/kafka_2.12-2.3.0.tgz
  cmd.run:
    - name: cd /opt && tar zxf kafka_2.12-2.3.0.tgz && mv kafka_2.12-2.3.0 /usr/local/kafka
    - unless: test -f /usr/local/kafka
kafka_config:
  file.managed:
    - name: /usr/local/kafka/config/server.properties
    - source: salt://kafka/files/server.properties
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    {% if grains['fqdn'] == 'LA-CEN-TOM-JT-24-70' %}
    - BLOCKERID: 1
    - KAFKA_IP: {{ pillar['kafka']['ip']['server1_ip'] }}
    {% elif grains['fqdn'] == 'LA-CEN-TOM-JT-24-71' %}
    - BLOCKERID: 2
    - KAFKA_IP: {{ pillar['kafka']['ip']['server2_ip'] }}
    {% elif grains['fqdn'] == 'LA-RED-KAFKA-JT-24-72' %}
    - BLOCKERID: 3
    - KAFKA_IP: {{ pillar['kafka']['ip']['server3_ip'] }}
    {% endif %}
    - defaults:
      ZOOK1_IP: {{ pillar['zookeeper']['ip']['server1_ip'] }}
      ZOOK2_IP: {{ pillar['zookeeper']['ip']['server2_ip'] }}
      ZOOK3_IP: {{ pillar['zookeeper']['ip']['server3_ip'] }}
kafka_server_start_file:
  file.managed:
    - name: /usr/local/kafka/bin/kafka-server-start.sh
    - source: salt://kafka/files/kafka-server-start.sh
    - user: root
    - group: root
    - mode: 755
kafka_server_stop_file:
  file.managed:
    - name: /usr/local/kafka/bin/kafka-server-stop.sh
    - source: salt://kafka/files/kafka-server-stop.sh
    - user: root
    - group: root
    - mode: 755
kafka_service:
  file.managed:
    - name: /lib/systemd/system/kafka.service
    - source: salt://kafka/files/kafka.service
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: kafka
    - enable: True
    - require:
      - file: kafka_config
    - watch:
      - file: kafka_config
