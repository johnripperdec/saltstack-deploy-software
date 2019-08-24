include:
  - dns.dns_install
master_view_conf:
  file.managed:
    - name: /var/named/chroot/etc/view.conf
    - source: salt://dns/files/dns_slave/view.conf.bak
    - user: named
    - group: named
    - mode: 644
chown_dns:
  cmd.run:
    - name: cd /var && chown -R named:named named/
dns_service:
  service.running:
    - name: named
    - enable: True

