net.ipv4.ip_local_port_range:
  sysctl.present:
    - value: 10000 65535
fs.file-max:
  sysctl.present:
    - value: 2000000
net.ipv4.ip_forward:
  sysctl.present:
    - value: 1
vm.swappiness:
  sysctl.present:
    - value: 0
net.ipv4.tcp_tw_reuse:
  sysctl.present:
    - value: 1
net.ipv4.tcp_fin_timeout:
  sysctl.present:
    - value: 10
net.ipv4.tcp_tw_recycle:
  sysctl.present:
    - value: 1
