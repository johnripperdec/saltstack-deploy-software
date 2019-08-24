include:
  - keepalived.install7
keepalived-system:
  file.managed:
    - name: /lib/systemd/system/keepalived.service
    - source: salt://keepalived/files/keepalived.service
    - user: root
    - group: root
    - mode: 644
keepalived7-server:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://keepalived/files/keepalived_jinja.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    {% if grains['fqdn'] == 'LA-CEN-TOM-JT-24-70' %}
    - ROUTEID: jtnode1
    - STATEID: MASTER
    - PRIORITYID: 150
    {% elif grains['fqdn'] == 'LA-CEN-TOM-JT-24-71' %}
    - ROUTEID: jtnode2
    - STATEID: BACKUP
    - PRIORITYID: 100
    {% endif %}
  service.running:
    - name: keepalived
    - enable: True
    - watch:
      - file: keepalived7-server
      - file: keepalived-system
