include:
  - nginx.nginx-install
nginxfz-config:
  file.managed:
    - name: /usr/local/nginx/conf/nginx.conf
    - source: salt://nginx-fz/files/nginx.conf
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
nginxfz-initsv:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://nginx-fz/files/nginx-init
    - user: www
    - group: www
    - mode: 755
  cmd.run:
    - name: chkconfig --add nginx
    - unless: chkconfig --list|grep nginx
    - require:
      - file: nginxfz-config
nginxfz-web:
  file.directory:
    - name: /opt/web
    - unless: test -d /opt/web
nginxfz-vhost-config:
  file.directory:
    - name: /usr/local/nginx/conf/vhost
    - unless: test -d /usr/local/nginx/conf/vhost
nginxfz-service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - file: nginxfz-initsv
    - watch:
      - file: nginxfz-config
      - file: nginxfz-vhost-config

