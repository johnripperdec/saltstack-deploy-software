include:
  - rabbitmq-install.rabbitmq-install
erlang_cokkie_file:
  file.managed:
    - name: /var/lib/rabbitmq/.erlang.cookie
    - source: salt://rabbitmq-cluster/files/.erlang.cookie
    - user: rabbitmq
    - group: rabbitmq
    - mode: 400
salve-init-file:
  file.managed:
    - name: /etc/init.d/rabbitmq-server
    - source: salt://rabbitmq-cluster/files/rabbitmq-server
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: erlang_cokkie_file
slave-service:
  service.running:
    - name: rabbitmq-server
    - enable: True
    - require:
      - file: salve-init-file
add_cluster_script:
  file.managed:
    - name: /tmp/add_rabbit_cluster.sh
    - source: salt://rabbitmq-cluster/files/add_rabbit_cluster.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - service: slave-service
  cmd.run:
    - name: /bin/bash /tmp/add_rabbit_cluster.sh
    - require:
      - file: add_cluster_script

