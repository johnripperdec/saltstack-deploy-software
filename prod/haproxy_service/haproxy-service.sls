include:
  - haproxy.install
haproxy-system:
  file.managed:
    - name: /lib/systemd/system/haproxy.service
    - source: salt://haproxy_service/files/haproxy.service
    - user: root
    - group: root
    - mode: 644
haproxy-service:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy_service/files/haproxy-outside.cfg
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: haproxy
    - enable: True
    - reload: True
    - require:
      - file: haproxy-system
    - watch:
      - file: haproxy-service
