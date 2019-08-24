include:
  - fastdfs.nginx-cache-install
nginx-cache-config:
  file.managed:
    - name: /usr/local/nginx/conf/nginx.conf
    - source: salt://fastdfs/files/nginx-cache.conf
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
nginx-cache-initsv:
  file.managed:
    - name: /lib/systemd/system/nginx.service
    - source: salt://fastdfs/files/service_file/nginx.service
    - user: www
    - group: www
    - mode: 644
nginx-cache-web:
  file.directory:
    - name: /opt/web
    - unless: test -d /opt/web
nginx-cache-vhost-config:
  file.directory:
    - name: /usr/local/nginx/conf/vhost
    - unless: test -d /usr/local/nginx/conf/vhost
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - file: nginx-cache-config
      - file: nginx-cache-initsv
    - watch:
      - file: nginx-cache-vhost-config

