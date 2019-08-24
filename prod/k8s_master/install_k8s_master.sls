dock_relay_pkg:
  pkg.installed:
    - names:
      - yum-utils
      - device-mapper-persistent-data
      - lvm2
      - wget
      - net-tools
dock_v17selinux_file:
  file.managed:
    - name: /opt/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm 
    - source: salt://k8s_master/files/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm 
docker_v17ce_file:
  file.managed:
    - name: /opt/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm 
    - source: salt://k8s_master/files/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm 
install_docker_v17:
  cmd.run:
    - name: cd /opt && yum localinstall docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm  docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm -y
    - require:
      - file: dock_v17selinux_file
      - file: docker_v17ce_file
  service.running:
    - name: docker
    - enable: True
    - require:
      - cmd: install_docker_v17
kubernetes_repo:
  file.managed:
    - name: /root/ku_repo.sh
    - source: salt://k8s_master/files/ku_repo.sh
    - user: root
    - group: root
    - mode: 755
    - unless: test -f /root/ku_repo.sh
  cmd.run:
    - name: /bin/bash /root/ku_repo.sh
    - reuqire:
      - file: kubernetes_repo
kubelet_install:
  pkg.installed:
    - names:
      - kubelet
      - kubeadm
      - kubectl
    - require:
      - cmd: kubernetes_repo
config_file_modify:
  file.managed:
    - name: /opt/k8s_config_modify.sh
    - source: salt://k8s_master/files/k8s_config_modify.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: /bin/bash -x /opt/k8s_config_modify.sh
    - require:
      - pkg: kubelet_install
      - file: config_file_modify

