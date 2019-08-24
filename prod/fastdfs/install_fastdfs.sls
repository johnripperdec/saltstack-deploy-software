include:
  - fastdfs.install_libfastcommon
fastdfs_file:
  file.managed:
    - name: /opt/fastdfs-5.12.zip
    - source: salt://fastdfs/files/fastdfs-5.12.zip
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/fastdfs-5.12.zip
  cmd.run:
    - name: cd /opt && unzip fastdfs-5.12.zip && cd fastdfs-master && ./make.sh && ./make.sh install 
    - unless: test -f /usr/bin/fdfs_trackerd &&  test -f /usr/bin/fdfs_storaged
