include:
  - zookeeper.zookeeper_install
my_id:
  cmd.run:
    - name: echo "3">/usr/local/zookeeper/zkdata/myid
zookeeper3_service:
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
      - file: zookeeper_conf
    - watch:
      - file: zookeeper_conf
