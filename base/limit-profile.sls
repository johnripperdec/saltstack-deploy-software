limit-profile:
  file.append:
    - name: /etc/profile
    - text:
      - ulimit -SHn 65535 
      - ulimit -c unlimited
      - ulimit -s unlimited
  cmd.run:
    - name: source /etc/profile
    - require:
      - file: limit-profile
    - watch:
      - file: limit-profile
