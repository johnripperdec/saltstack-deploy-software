epel-yum:
  file.managed:
    - name: /opt/epel-release-latest-7.noarch.rpm
    - source: salt://pip/files/epel-release-latest-7.noarch.rpm
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: cd /opt && rpm -ivh epel-release-latest-7.noarch.rpm
    - require:
      - file: epel-yum
install-pip:
  pkg.installed:
    - names:
      - python-pip
    - require:
      - cmd: epel-yum
  cmd.run:
    - name: pip install --upgrade pip
    - require:
      - pkg: install-pip
      
