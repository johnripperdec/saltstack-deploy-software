include:
  - dns.dns_install
master_view_conf:
  file.managed:
    - name: /var/named/chroot/etc/view.conf
    - source: salt://dns/files/dns_master/view.conf.bak
    - user: named
    - group: named
    - mode: 644
master_zone_cnf:
  file.managed:
    - name: /var/named/chroot/etc/dengwenyan.com.zone
    - source: salt://dns/files/dns_master/dengwenyan.com.zone
    - user: named
    - group: named
    - mode: 644
master_ptr_cnf:
  file.managed:
    - name: /var/named/chroot/etc/168.192.zone
    - source: salt://dns/files/dns_master/168.192.zone
    - user: named
    - group: named
    - mode: 644
dns_service:
  service.running:
    - name: named
    - enable: True

