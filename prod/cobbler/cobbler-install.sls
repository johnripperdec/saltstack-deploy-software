cobbler-ce7-repo:
  file.managed:
    - name: /etc/yum.repos.d/cobbler.repo
    - source: salt://cobbler/files/cobbler.repo
    - user: root
    - group: root
    - mode: 644
cobbler-pkg:
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
      - file: cobbler-ce7-repo
cobbler-wsgi-config:
  file.managed:
    - name: /etc/httpd/conf.d/wsgi.conf
    - source: salt://cobbler/files/wsgi.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cobbler-pkg
cobbler-tftp-config:
  file.managed:
    - name: /etc/cobbler/tftpd.template
    - source: salt://cobbler/files/tftpd.template
    - user: root
    - group: root
    - mode: 644
cobbler-config:
  file.managed:
    - name: /etc/cobbler/settings
    - source: salt://cobbler/files/settings
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
cobbler-dhcp-config:
  file.managed:
    - name: /etc/cobbler/dhcp.template
    - source: salt://cobbler/files/dhcp.template
    - user: root
    - group: root
    - mode: 644
cobbler-sysconfig-dhcpd:
  file.append:
    - name: /etc/sysconfig/dhcpd
    - text:
      - DHCPDARGS="eno16777736"
httpd-service:
  service.running:
    - name: httpd
    - enable: True
cobbler-service:
  service.running:
    - name: cobblerd
    - enable: True
    - require:
      - file: cobbler-config
cobbler-tftp:
  service.running:
    - name: tftp
    - enable: True
