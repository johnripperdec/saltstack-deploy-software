zabbixagent-pkg:
  pkg.installed:
    - names:
      - zabbix-agent
zabbix_agent_conf:
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://zabbix3-4/files/zabbix_agent.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      ZB_SERVER_IP: {{ pillar['zabbix']['zabbix_ser_ip'] }}
      Hostname: {{ grains['fqdn'] }}
zabbixagent-service:
  service.running:
    - name: zabbix-agent
    - enable: True
    - reuqire:
      - file: zabbix_agent_conf
