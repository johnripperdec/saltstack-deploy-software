libfastcommon_file:
  file.managed:
    - name: /opt/libfastcommon-1.40.zip
    - source: salt://fastdfs/files/libfastcommon-1.40.zip
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/libfastcommon-1.40.zip
  cmd.run:
    - name: cd /opt/ && unzip libfastcommon-1.40.zip && cd libfastcommon-master && ./make.sh && ./make.sh install
    - unless: test -f /usr/lib/libfastcommon.so && test -f /usr/lib64/libfastcommon.so
