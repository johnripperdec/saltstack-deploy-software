cobbler-yum:
  file.managed:
    - name: /etc/yum.repos.d/cobbler-config.repo
    - source: salt://yum-replace/files/cobbler-config.repo
    - user: root
    - group: root
    - mode: 644
