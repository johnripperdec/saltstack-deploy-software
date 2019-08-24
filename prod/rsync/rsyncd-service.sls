include:
  - user.www
rsyncd-yum:
  pkg.installed:
    - names:
      - rsync
      - xinetd
xinted-config:
  file.managed:
    - name: /etc/xinetd.d/rsync 
    - source: salt://rsync/files/rsync
    - user: root
    - group: root
    - mode: 644
rsync-config:
  file.managed:
    - name: /etc/rsyncd.conf
    - source: salt://rsync/files/rsyncd.conf
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: xinetd
    - enable: True
    - require:
      - pkg: rsyncd-yum
    - watch:
      - file: rsync-config
rsync-passwd-config:
  file.managed:
    - name: /etc/rsync.password
    - source: salt://rsync/files/rsync.password
    - user: root
    - group: root
    - mode: 600
rsync_web-bao:
  file.directory:
    - name: /opt/package_revice
    - user: www
    - group: www
    - mode: 644
    - unless: test -d /opt/package_revice
