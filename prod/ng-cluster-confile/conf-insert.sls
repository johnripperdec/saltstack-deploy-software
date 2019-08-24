conf-cluser-append:
  file.append:
    - name: /opt/test.sh
    - text:
      - server {{ salt['network.interface_ip']('eno16777736') }};
