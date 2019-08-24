dir-create:
  file.directory:
    - name: /opt/soft
    - user: root
    - group: root
    - unless: test -d /opt/soft
erlang-file:
  file.managed:
    - name: /opt/soft/erlang-19.0.4-1.el6.x86_64.rpm
    - source: salt://rabbitmq-install/files/erlang-19.0.4-1.el6.x86_64.rpm
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: dir-create
socat-file:
  file.managed:
    - name: /opt/soft/socat-1.7.2.3-1.el6.x86_64.rpm 
    - source: salt://rabbitmq-install/files/socat-1.7.2.3-1.el6.x86_64.rpm 
    - user: root
    - group: root
    - mode: 644
rabbitmq-file:
  file.managed:
    - name: /opt/soft/rabbitmq-server-3.6.10-1.el6.noarch.rpm
    - source: salt://rabbitmq-install/files/rabbitmq-server-3.6.10-1.el6.noarch.rpm
    - user: root
    - group: root
    - mode: 644
install-script:
  file.managed:
    - name: /opt/soft/rabbit.sh
    - source: salt://rabbitmq-install/files/rabbit.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: erlang-file
      - file: socat-file
      - file: rabbitmq-file
  cmd.run:
    - name: cd /opt/soft && /bin/bash  rabbit.sh
    - require:
      - file: install-script
