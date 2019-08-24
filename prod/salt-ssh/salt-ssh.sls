minion_yum:
  file.managed:
    - name: /opt/salt-repo-latest-2.el6.noarch.rpm
    - source: salt://salt-ssh/files/salt-repo-latest-2.el6.noarch.rpm
    - mode: 644
    - user: root
    - group: root
    - unless: test -f /opt/salt-repo-latest-2.el6.noarch.rpm
  cmd.run:
    - name: cd /opt && rpm -ivh salt-repo-latest-2.el6.noarch.rpm
    - unless: test -f /etc/yum.repos.d/salt-latest.repo
    - require:
      - file: minion_yum
pkg_saltminion:
  pkg.installed:
    - names:
      - salt-minion
    - require:
      - cmd: minion_yum
saltminion_config:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://salt-ssh/files/minion
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: pkg_saltminion
saltminion_servce:
  service.running:
    - name: salt-minion
    - enable: True
    - reload: True
    - require:
      - file: saltminion_config
    - watch:
      - file: saltminion_config
