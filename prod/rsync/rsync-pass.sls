rsyncs-passwd-config:
  file.managed:
    - name: /etc/rsync.password
    - source: salt://rsync/files/rsyncclient.password 
    - user: root
    - group: root
    - mode: 600
