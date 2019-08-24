postgresql-repo:
  file.managed:
    - name: /etc/yum.repos.d/pgdg-96-redhat.repo
    - source: salt://postgresql/files/pgdg-96-redhat.repo
    - user: root
    - group: root
    - mode: 644
postgresql-pkg:
  pkg.installed:
    - name: postgresql96-server
    - require:
      - file: postgresql-repo
  cmd.run:
    - name: /etc/init.d/postgresql-9.6 initdb
    - unless:
      - pkg: postgresql-pkg
postgresql-config:
  file.managed:
    - name: /var/lib/pgsql/9.6/data/postgresql.conf
    - source: salt://postgresql/files/postgresql.conf
    - user: postgres
    - group: postgres
    - mode: 600
    - require:
      - cmd: postgresql-pkg
postgresql-service:
  service.running:
    - name: postgresql-9.6
    - enable: True
    - reload: True
    - require:
      - file: postgresql-config
    - watch:
      - file: postgresql-config
