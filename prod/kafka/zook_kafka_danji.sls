include:
  - zookeeper.zookeeper_danji
kafka_danji_file:
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
kafka_danji_config:
  file.managed:
    - name: /usr/local/kafka/config/server.properties
    - source: salt://kafka/files/server_danji.properties
    - user: root
    - group: root
    - mode: 644
  file.managed:
    - name: /usr/local/kafka/bin/kafka-server-start.sh
    - source: salt://kafka/files/kafka-server-start.sh
    - user: root
    - group: root
    - mode: 755
kafka_danji_server_stop_file:
  file.managed:
    - name: /usr/local/kafka/bin/kafka-server-stop.sh
    - source: salt://kafka/files/kafka-server-stop.sh
    - user: root
    - group: root
    - mode: 755
kafka_danji_service:
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
      - file: kafka_danji_config
    - watch:
      - file: kafka_danji_config
