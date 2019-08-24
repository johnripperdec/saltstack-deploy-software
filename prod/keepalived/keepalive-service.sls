include:
  - keepalived.install
keepalived-server:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://keepalived/files/keepalived_jinja.conf
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    {% if grains['fqdn'] == 'LA-PUB-NGINX1-CEN-10-10-24-41' %}
    - ROUTEID: jtnode1
    - STATEID: MASTER
    - PRIORITYID: 150
    {% elif grains['fqdn'] == 'LA-PUB-NGINX2-CEN-10-10-24-42' %}
    - ROUTEID: jtnode2
    - STATEID: BACKUP
    - PRIORITYID: 100
    {% endif %}
  service.running:
    - name: keepalived
    - enable: True
    - watch:
      - file: keepalived-server
