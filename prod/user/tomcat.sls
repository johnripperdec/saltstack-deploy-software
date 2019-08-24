www-tomcat-group:
  group.present:
    - name: tomcat
    - gid: 1002
  user.present:
    - name: tomcat
    - fullname: tomcat
    - shell: /bin/bash
    - uid: 1002
    - gid: 1002
