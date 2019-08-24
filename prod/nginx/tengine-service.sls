include:
  - nginx.tengine-install
nginx-config:
  file.managed:
    - name: /usr/local/nginx/conf/nginx.conf
    - source: salt://nginx/files/tengine.conf
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
nginx-initsv:
  file.managed:
    - name: /lib/systemd/system/nginx.service
    - source: salt://nginx/files/nginx.service
    - user: www
    - group: www
    - mode: 755
nginx-web:
  file.directory:
    - name: /opt/web
    - unless: test -d /opt/web
nginx-vhost-config:
  file.directory:
    - name: /usr/local/nginx/conf/vhost
    - unless: test -d /usr/local/nginx/conf/vhost
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - file: nginx-config
      - file: nginx-initsv
    - watch:
      - file: nginx-vhost-config

