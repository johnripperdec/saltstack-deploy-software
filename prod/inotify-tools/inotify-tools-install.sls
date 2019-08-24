inotify-tools-source:
  file.managed:
    - name: /opt/inotify-tools-3.14.tar.gz
    - source: salt://inotify-tools/files/inotify-tools-3.14.tar.gz
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /opt && tar -zxvf inotify-tools-3.14.tar.gz && cd inotify-tools-3.14/ && ./configure --prefix=/usr/local/inotify-tools && make && make install
    - unless: test -d /usr/local/inotify-tools
    - require:
      - pkg: pkg-install
      - file: inotify-tools-source
insc-dr:
  file.directory:
    - name: /opt/script
    - user: root
    - group: root
    - mode: 644
    - unless: test -d /opt/script
inotify-service:
  file.managed:
    - name: /opt/script/inotifyrsync.sh
    - source: salt://inotify-tools/files/inotifyrsync.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: insc-dr

salt://inotify-tools/files/inotify.sh:
  cmd.script:
    - shell: /bin/sh
    - bg: True
    - watch:
      - file: inotify-service
