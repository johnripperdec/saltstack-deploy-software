include:
  - fastdfs.install_fastdfs
fastdfs_dic:
  file.directory:
    - name: /home/fastdfs
    - user: root
    - group: root
    - mode: 644
    - unless: test -d /home/fastdfs
storage_conf:
  file.managed:
    - name: /etc/fdfs/storage.conf
    - source: salt://fastdfs/files/conf/storage.conf
    - user: root
    - group: root
    - mode: 644
storage_init:
  file.managed:
    - name: /etc/init.d/fdfs_storaged
    - source: salt://fastdfs/files/fdfs_storaged
    - user: root
    - group: root
    - mode: 755
storage_system:
  file.managed:
    - name: /lib/systemd/system/fdfs_storaged.service
    - source: salt://fastdfs/files/service_file/fdfs_storaged.service
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: fdfs_storaged
    - enable: True
    - require:
      - file: storage_conf
      - file: storage_system
      - file: storage_init
    - watch:
      - file: storage_conf
