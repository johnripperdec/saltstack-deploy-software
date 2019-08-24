dns_pkg:
  pkg.installed:
    - names:
      - bind
      - bind-utils
      - bind-chroot
      - bind-devel
dns_named_config:
  file.managed:
    - name: /etc/named.conf
    - source: salt://dns/files/dns_master/named.conf
    - user: root
    - group: named
    - mode: 640
    - require:
      - pkg: dns_pkg
rndc_key:
  file.managed:
    - name: /etc/rndc.key
    - source: salt://dns/files/dns_master/rndc.key
    - user: root
    - group: root
    - mode: 644
rndc_conf:
  file.managed:
    - name: /etc/rndc.conf
    - source: salt://dns/files/dns_master/rndc.conf
    - user: root
    - group: root
    - mode: 644

