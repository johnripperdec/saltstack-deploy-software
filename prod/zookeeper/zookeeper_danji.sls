include:
  - jdk.jdk-install
all_in_one_file:
  file.managed:
    - name: /opt/zookeeper-3.4.12.tar.gz
    - source: salt://zookeeper/files/zookeeper-3.4.12.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/zookeeper-3.4.12.tar.gz
  cmd.run:
    - name: cd /opt && tar zxf zookeeper-3.4.12.tar.gz && mv zookeeper-3.4.12 /usr/local/zookeeper
    - unless: test -d /usr/local/zookeeper
all_in_one_dir:
  file.directory:
    - name: /usr/local/zookeeper/zkdata
    - unless: test -d /usr/local/zookeeper/zkdata
    - require:
      - cmd: all_in_one_file
all_in_log_dir:
  file.directory:
    - name: /usr/local/zookeeper/zklog
    - unless: test -d /usr/local/zookeeper/log
all_start_file:
  file.managed:
    - name: /usr/local/zookeeper/bin/zkServer.sh
    - source: salt://zookeeper/files/zkServer.sh
    - user: root
    - group: root
    - mode: 755
all_in_one_conf:
  file.managed:
    - name: /usr/local/zookeeper/conf/zoo.cfg
    - source: salt://zookeeper/files/zoo_danji.cfg
    - user: root
    - group: root
    - mode: 644
all_zookeeper_service:
  file.managed:
    - name: /lib/systemd/system/zookeeper.service
    - source: salt://zookeeper/files/zookeeper.service
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: zookeeper
    - enable: True
    - require:
      - file: all_in_one_conf
    - watch:
      - file: all_in_one_conf
