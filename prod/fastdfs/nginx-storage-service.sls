include:
  - fastdfs.nginx-storage-install
  - fastdfs.storage_service
nginx-storage-config:
  file.managed:
    - name: /usr/local/nginx/conf/nginx.conf
    - source: salt://fastdfs/files/nginx-storage.conf
    - user: www
    - group: www
    - mode: 644
    - template: jinja
    - defaults:
      USER: {{ pillar['nginx']['nginx_user'] }}
      ROOT: {{ pillar['nginx']['web_root'] }}
      GROUP: {{ pillar['nginx']['nginx_group'] }}
      MAX_OPEN_FILE: {{ pillar['nginx']['max_open_file'] }}
      WEB_ROOT: {{ pillar['nginx']['web_root'] }}
      LOG_ROOT: {{ pillar['nginx']['log_root'] }}
mod_fastdfs_file:
  file.managed:
    - name: /etc/fdfs/mod_fastdfs.conf
    - source: salt://fastdfs/files/conf/mod_fastdfs.conf
    - user: root
    - group: root
    - mode: 644
http_fastdfs_file:
  file.managed:
    - name: /etc/fdfs/http.conf
    - source: salt://fastdfs/files/conf/http.conf
    - user: root
    - group: root
    - mode: 644
mime_fastdfs_file:
  file.managed:
    - name: /etc/fdfs/mime.types
    - source: salt://fastdfs/files/conf/mime.types
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: ln -s /home/fastdfs/data  /home/fastdfs/data/M00
    - require:
      - service: storage_system
nginx-storage-initsv:
  file.managed:
    - name: /lib/systemd/system/nginx.service
    - source: salt://fastdfs/files/service_file/nginx.service
    - user: www
    - group: www
    - mode: 644
nginx-storage-web:
  file.directory:
    - name: /opt/web
    - unless: test -d /opt/web
nginx-storage-vhost-config:
  file.directory:
    - name: /usr/local/nginx/conf/vhost
    - unless: test -d /usr/local/nginx/conf/vhost
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - file: nginx-storage-config
      - file: nginx-storage-initsv
    - watch:
      - file: nginx-storage-vhost-config

