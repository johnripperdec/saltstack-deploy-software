include:
  - fastdfs.install_fastdfs
  - pcre.pcre-install
  - user.www
fastfs_dictory:
  file.directory:
    - name: /home/fastdfs
    - user: root
    - group: root
    - mode: 755
    - unless: test -d /home/fastdfs
all_in_tr_conf:
  file.managed:
    - name: /etc/fdfs/tracker.conf
    - source: salt://fastdfs/files/conf/tracker.conf
    - user: root
    - group: root
    - mode: 644
all_in_st_conf:
  file.managed:
    - name: /etc/fdfs/storage.conf
    - source: salt://fastdfs/files/conf/storage.conf
    - user: root
    - group: root
    - mode: 644
all_in_tr_system:
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
      - file: all_in_tr_conf
      - file: all_in_tr_system
    - watch:
      - file: all_in_tr_conf
all_in_st_system:
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
      - file: all_in_st_conf
      - file: all_in_st_system
    - watch:
      - file: all_in_st_conf

ngx-cache-purge:
  file.managed:
    - name: /opt/ngx_cache_purge-2.3.tar.gz
    - source: salt://fastdfs/files/ngx_cache_purge-2.3.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/ngx_cache_purge-2.3.tar.gz
  cmd.run:
    - name: cd /opt && tar zxf ngx_cache_purge-2.3.tar.gz
    - unless: test -d /opt/ngx_cache_purge-2.3
fastdfs-module:
  file.managed:
    - name: /opt/fastdfs-nginx-module_v1.16.tar.gz
    - source: salt://fastdfs/files/fastdfs-nginx-module_v1.16.tar.gz
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/fastdfs-nginx-module_v1.16.tar.gz
  cmd.run:
    - name: cd /opt && tar zxf fastdfs-nginx-module_v1.16.tar.gz
    - unless: test -d /opt/fastdfs-nginx-module
nginx-all_in-source:
  file.managed:
    - name: /opt/nginx-1.10.3.tar.gz
    - source: salt://fastdfs/files/nginx-1.10.3.tar.gz
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: cd /opt && tar zxf nginx-1.10.3.tar.gz && cd nginx-1.10.3 &&./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --with-file-aio --with-http_dav_module --with-pcre=/opt/pcre-8.37 --add-module=/opt/fastdfs-nginx-module/src --add-module=/opt/ngx_cache_purge-2.3 && make && make install && chown -R www:www /usr/local/nginx
    - unless: test -d /usr/local/nginx
    - require:
      - user: www-user-group
      - file: nginx-all_in-source

nginx-all_in-config:
  file.managed:
    - name: /usr/local/nginx/conf/nginx.conf
    - source: salt://fastdfs/files/all_in_one_nginx.conf
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
mod_all_in_fastdfs_file:
  file.managed:
    - name: /etc/fdfs/mod_fastdfs.conf
    - source: salt://fastdfs/files/conf/mod_fastdfs.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - service: all_in_st_system
http_all_in_fastdfs_file:
  file.managed:
    - name: /etc/fdfs/http.conf
    - source: salt://fastdfs/files/conf/http.conf
    - user: root
    - group: root
    - mode: 644
mime_all_in_fastdfs_file:
  file.managed:
    - name: /etc/fdfs/mime.types
    - source: salt://fastdfs/files/conf/mime.types
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: ln -s /home/fastdfs/data  /home/fastdfs/data/M00
nginx-all_in-initsv:
  file.managed:
    - name: /lib/systemd/system/nginx.service
    - source: salt://fastdfs/files/service_file/nginx.service
    - user: www
    - group: www
    - mode: 644
nginx-all_in-web:
  file.directory:
    - name: /opt/web
    - unless: test -d /opt/web
nginx-all_in-vhost-config:
  file.directory:
    - name: /usr/local/nginx/conf/vhost
    - unless: test -d /usr/local/nginx/conf/vhost
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - file: nginx-all_in-config
      - file: nginx-all_in-initsv
    - watch:
      - file: nginx-all_in-vhost-config

