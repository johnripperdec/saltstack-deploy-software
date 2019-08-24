jenkins-source:
  file.managed:
    - name: /opt/jdk-8u91-linux-x64.tar.gz
    - source: salt://jenkins/files/jdk-8u91-linux-x64.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /opt && tar -zxf jdk-8u91-linux-x64.tar.gz
    - unless: test -d /opt/jdk1.8.0_91
    - require:
      - file: jenkins-source
java-init:
  file.append:
    - name: /etc/profile
    - text:
      - export JAVA_HOME=/opt/jdk1.8.0_91
      - export JAVA_BIN=/opt/jdk1.8.0_91/bin
      - export PATH=$PATH:$JAVA_HOME/bin
      - export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
    - require:
      - cmd: jenkins-source
  cmd.run:
    - name: source /etc/profile
jenkins-yum:
  file.managed:
    - name: /etc/yum.repos.d/jenkins.repo
    - source: salt://jenkins/files/jenkins.repo
    - user: root
    - group: root
    - mode: 755
    - unless: test -f /etc/yum.repos.d/jenkins.repo
  cmd.run:
    - name: rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
    - require:
      - file: jenkins-yum
jenkins-installd:
  pkg.installed:
    - names:
      - jenkins
    - require:
      - cmd: jenkins-yum

