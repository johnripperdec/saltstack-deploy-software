mysql-user-group:
  group.present:
    - name: mysql
    - gid: 1001
  user.present:
    - name: mysql
    - uid: 1001
    - fullname: mysql
    - gid: 1001
    - shell: /sbin/nologin
