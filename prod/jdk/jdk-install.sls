jdk-source:
  file.managed:
    - name: /opt/jdk-8u91-linux-x64.tar.gz
    - source: salt://jdk/files/jdk-8u91-linux-x64.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /opt && tar -zxf jdk-8u91-linux-x64.tar.gz
    - unless: test -d /opt/jdk1.8.0_91
    - require:
      - file: jdk-source
jdk-etc-source:
  file.append:
    - name: /etc/profile
    - text:
      - export JAVA_HOME=/opt/jdk1.8.0_91
      - export JAVA_BIN=/opt/jdk1.8.0_91/bin
      - export PATH=$PATH:$JAVA_HOME/bin
      - export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
    - require:
      - cmd: jdk-source
  cmd.run:
    - name: source /etc/profile
