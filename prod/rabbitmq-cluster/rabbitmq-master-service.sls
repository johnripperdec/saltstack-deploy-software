include:
  - rabbitmq-install.rabbitmq-install
replace-initserver-file:
  file.managed:
    - name: /etc/init.d/rabbitmq-server
    - source: salt://rabbitmq-cluster/files/rabbitmq-server
    - user: root
    - group: root
    - mode: 755
erlang-cokie-copy:
  file.managed:
    - name: /opt/copy_master_erlang_cokie.sh
    - source: salt://rabbitmq-cluster/files/copy_master_erlang_cokie.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /opt && expect copy_master_erlang_cokie.sh
    - require:
      - file: erlang-cokie-copy
disc-service:
  service.running:
    - name: rabbitmq-server
    - enable: rabbitmq-server
    - require:
      - file: replace-initserver-file
