mongo_repo:
  file.managed:
    - name: /etc/yum.repos.d/mongodb_34.repo.bak
    - source: salt://mongodb/files/mongodb_34.repo
    - user: root
    - group: root 
    - mode: 644
mongo-pkg:
  pkg.installed:
    - name: mongodb-org
    - require:
      - file: mongo_repo
