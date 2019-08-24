file-line:
  file.line:
    - name: /opt/nginx.conf
    - content:  server {{ salt['network.interface_ip']('eno16777736') }}
    - mode: insert
    - match: "upstream adv1 {"
    - location:
      - start: "{"
      - end: "v1"
    - backup: ".bak2"
    - show_changes: True
