nginx-confile:
  file.blockreplace:
    - name: /opt/nginx.conf
    - marker_start: "upstream user1 {"
    - marker_end: "server"
    - content: server {{ salt['network.interface_ip']('eno16777736') }};
    - append_if_not_found: True
    - backup: '.bak'
    - show_changes: True
nginx-config-false:
  file.line:
    - name: /opt/nginx.conf
    - content: "#server {{ salt['network.interface_ip']('eno16777736') }};"
    - match: "server {{ salt['network.interface_ip']('eno16777736') }};" 
    - mode: replace
nginx-file-rescyle:
  file.accumulated:
    - filename: /opt/nginx.conf
    - name: nginx-rescyle
    - text: server {{ salt['network.interface_ip']('eno16777736') }};
    - require_in:
      - file: nginx-confile
