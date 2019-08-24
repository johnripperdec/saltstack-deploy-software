include:
  - user.tomcat
file-dir:
  file.directory:
    - name: /opt/soft
    - user: root
    - group: root 
    - unless: test -d /opt/soft
file-apache-dir:
  file.directory:
    - name: /home/apache-tomcat
    - user: root
    - group: root 
    - unless: test -d /home/apache-tomcat
web-tomcat-dir:
  file.directory:
    - name: /webapps
    - user: tomcat
    - group: tomcat
    - unless: test -d /webapps
jdk-file:
  file.managed:
    - name: /opt/soft/jdk-8u45-linux-x64.tar.gz
    - source: salt://tomcat/files/jdk-8u45-linux-x64.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/soft/jdk-8u45-linux-x64.tar.gz
    - require:
      - file: file-dir
  cmd.run:
    - name: cd /opt/soft/ && tar -xf jdk-8u45-linux-x64.tar.gz && mv jdk1.8.0_45/ /home/apache-tomcat/
    - unless: test -d /home/apache-tomcat/jdk1.8.0_45
    - require:
      - file: file-apache-dir
apache-tomcat-file:
  file.managed:
    - name: /opt/soft/apache-tomcat-8.5.16.tar.gz
    - source: salt://tomcat/files/apache-tomcat-8.5.16.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/soft/apache-tomcat-8.5.16.tar.gz
  cmd.run:
    - name: cd /opt/soft && tar -xf apache-tomcat-8.5.16.tar.gz && mv apache-tomcat-8.5.16 /home/apache-tomcat/apache-tomcat
    - unless: test -d /home/apache-tomcat/apache-tomcat
tomcat-server-conf:
  file.managed:
    - name: /home/apache-tomcat/apache-tomcat/conf/server.xml
    - source: salt://tomcat/files/server.xml
    - user: tomcat
    - group: tomcat
    - mode: 600
tomcat_catalina_opts:
  file.managed:
    - name: /home/apache-tomcat/apache-tomcat/bin/setenv.sh
    - source: salt://tomcat/files/setenv.sh
    - user: tomcat
    - group: tomcat
    - mode: 755
chown_tomcat:
  cmd.run:
    - name: echo "tomcat"| passwd --stdin tomcat && chown -R tomcat.tomcat /home/apache-tomcat/apache-tomcat  && chown -R tomcat.tomcat /home/apache-tomcat/jdk1.8.0_45
    - require:
      - cmd: apache-tomcat-file
security_tomcat:
  cmd.run:
    - name: cd /home/apache-tomcat/apache-tomcat/webapps && rm -rf  docs/ examples/ host-manager/ manager/ && cd /home/apache-tomcat/apache-tomcat/conf/ &&  rm -rf  tomcat-users.xml &&  cd /home/apache-tomcat/apache-tomcat/webapps && mv ROOT /webapps && chown -R tomcat.tomcat /webapps
    - unless: test -d /webapps/ROOT
startup-file:
  file.managed:
    - name: /home/apache-tomcat/apache-tomcat/bin/startup.sh
    - source: salt://tomcat/files/startup.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - cmd: apache-tomcat-file
shutdown-file:
  file.managed:
    - name: /home/apache-tomcat/apache-tomcat/bin/shutdown.sh
    - source: salt://tomcat/files/shutdown.sh
    - user: root
    - group: root
    - mode: 755
tomcat-init:
  file.managed:
    - name: /etc/init.d/tomcat
    - source: salt://tomcat/files/tomcat-init
    - user: root
    - group: root
    - mode: 755
tomcat-system:
  file.managed:
    - name: /lib/systemd/system/tomcat.service
    - source: salt://tomcat/files/tomcat.service
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: tomcat-init
tomcat-service:
  service.running:
    - name: tomcat
    - enable: tomcat
    - require:
      - file: tomcat-system