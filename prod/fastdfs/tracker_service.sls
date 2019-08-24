include:
  - fastdfs.install_fastdfs
fastfs_dictory:
  file.directory:
    - name: /home/fastdfs
    - user: root
    - group: root
    - mode: 755
    - unless: test -d /home/fastdfs
tracker_conf:
  file.managed:
    - name: /etc/fdfs/tracker.conf
    - source: salt://fastdfs/files/conf/tracker.conf
    - user: root
    - group: root
    - mode: 644
tracker_init:
  file.managed:
    - name: /etc/init.d/fdfs_trackerd
    - source: salt://fastdfs/files/fdfs_trackerd
    - user: root
    - group: root
    - mode: 755
tracker_system:
  file.managed:
    - name: /lib/systemd/system/fdfs_trackerd.service
    - source: salt://fastdfs/files/service_file/fdfs_trackerd.service
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: fdfs_trackerd
    - enable: True
    - require:
      - file: tracker_conf
      - file: tracker_system
      - file: tracker_init
    - watch:
      - file: tracker_conf
