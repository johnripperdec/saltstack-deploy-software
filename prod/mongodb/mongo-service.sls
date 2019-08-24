include:
  - mongodb.mongo-install
mongo_dictory:
  cmd.run:
    - name: mkdir -p /home/mongodb/mongodata && mkdir -p /home/mongodb/mongolog && chown -R mongod.mongod /home/mongodb/
    - unless: test -d /home/mongodb/mongolog
mong-config:
  file.managed:
    - name: /etc/mongod.conf
    - source: salt://mongodb/files/mongod.conf
    - user: root
    - group: root
    - mode: 644
mongo-service:
  service.running:
    - name: mongod
    - enable: True
    - reload: True
    - watch:
      - file: mong-config
