include:
  - jdk.jdk-install
zookeeper_file:
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
zookeeper_start_file:
  file.managed:
    - name: /usr/local/zookeeper/bin/zkServer.sh
    - source: salt://zookeeper/files/zkServer.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - cmd: zookeeper_file
data_dir:
  file.directory:
    - name: /usr/local/zookeeper/zkdata
    - unless: test -d /usr/local/zookeeper/zkdata
log_dir:
  file.directory:
    - name: /usr/local/zookeeper/zklog
    - unless: test -d /usr/local/zookeeper/zklog
zookeeper_conf:
  file.managed:
    - name: /usr/local/zookeeper/conf/zoo.cfg
    - source: salt://zookeeper/files/zoo.cfg
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      SERVER1_IP: {{ pillar['zookeeper']['ip']['server1_ip'] }}
      SERVER2_IP: {{ pillar['zookeeper']['ip']['server2_ip'] }}
      SERVER3_IP: {{ pillar['zookeeper']['ip']['server3_ip'] }}
      LISTEN_PORT: {{ pillar['zookeeper']['zkport']['listen_port'] }}
      VOTE_PORT: {{ pillar['zookeeper']['zkport']['vote_port'] }}
      SERVER1_MYID: {{ pillar['zookeeper']['my_id']['server1_myid'] }}
      SERVER2_MYID: {{ pillar['zookeeper']['my_id']['server2_myid'] }}
      SERVER3_MYID: {{ pillar['zookeeper']['my_id']['server3_myid'] }}
