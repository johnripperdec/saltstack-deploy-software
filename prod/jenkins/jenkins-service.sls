include:
  - jenkins.jenkins-init
jenkins-srv:
  file.managed:
    - name:  /lib/systemd/system/jenkins.service
    - source: salt://jenkins/files/jenkins.service
    - user: root
    - group: root
    - mode: 755
jenkins-file:
  file.managed:
    - name: /etc/init.d/jenkins
    - source: salt://jenkins/files/jenkins
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: jenkins-srv
  service.running:
    - name: jenkins
    - enable: True
    - reload: True
    - require:
      - file: jenkins-file
    
