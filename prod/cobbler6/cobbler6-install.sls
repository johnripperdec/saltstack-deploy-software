cobbler6-repo:
  file.managed:
    - name: /etc/yum.repos.d/epel6.repo
    - source: salt://cobbler6/files/epel-6.repo
    - user: root
    - group: root
    - mode: 644
cobbler6-pkg:
  pkg.installed:
    - names:
      - cobbler
      - tftp
      - tftp-server
      - xinetd
      - dhcp
      - httpd
      - rsync
      - pykickstart
    - require:
      - file: cobbler6-repo
cobbler6-wsgi-config:
  file.managed:
    - name: /etc/httpd/conf.d/wsgi.conf
    - source: salt://cobbler6/files/wsgi.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cobbler6-pkg
cobbler6-tftp-config:
  file.managed:
    - name: /etc/cobbler/tftpd.template
    - source: salt://cobbler6/files/tftpd.template
    - user: root
    - group: root
    - mode: 644
cobbler6-rsync-config:
  file.managed:
    - name: /etc/xinetd.d/rsync
    - source: salt://cobbler6/files/rsync
    - user: root
    - group: root
    - mode: 644
cobbler6-config:
  file.managed:
    - name: /etc/cobbler/settings
    - source: salt://cobbler6/files/settings
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      default_password_crypted: {{ pillar['cobbler']['default_password_crypted'] }}
      next_server: {{ pillar['cobbler']['next_server'] }}
      server: {{ pillar['cobbler']['server'] }}
      manage_dhcp: {{ pillar['cobbler']['manage_dhcp'] }}
      default_kickstart: {{ pillar['cobbler']['default_kickstart'] }}
cobbler6-dhcp-config:
  file.managed:
    - name: /etc/cobbler/dhcp.template
    - source: salt://cobbler6/files/dhcp.template
    - user: root
    - group: root
    - mode: 644
get-load-files:
  file.recurse:
    - source: salt://cobbler6/files/loaders
    - name: /var/lib/cobbler/loaders
    - user: root
    - group: root 
    - dir_mode: 755
    - file_mode: 644
    - mkdirs: True
service-restart:
  cmd.run:
    - name: service cobblerd restart &&  service xinetd restart
httpd6-service:
  service.running:
    - name: httpd
    - enable: True
cobbler6-service:
  service.running:
    - name: cobblerd
    - enable: True
cobbler6-tftp:
  service.running:
    - name: xinetd 
    - enable: True
