dock_node_pkg:
  pkg.installed:
    - names:
      - yum-utils
      - device-mapper-persistent-data
      - lvm2
      - wget
      - net-tools
dock_selinux_file:
  file.managed:
    - name: /opt/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm 
    - source: salt://k8s_node/files/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm 
docker_ce_file:
  file.managed:
    - name: /opt/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm 
    - source: salt://k8s_node/files/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm
    - user: root
    - group: root
    - mode: 644
    - unless: test -f /opt/docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm 
install_docker:
  cmd.run:
    - name: cd /opt && yum localinstall docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm  docker-ce-17.03.2.ce-1.el7.centos.x86_64.rpm -y
    - require:
      - file: dock_selinux_file
      - file: docker_ce_file
  service.running:
    - name: docker
    - enable: True
    - require:
      - cmd: install_docker
kubernetes_repo_yum:
  file.managed:
    - name: /root/ku_repo.sh
    - source: salt://k8s_node/files/ku_repo.sh
    - user: root
    - group: root
    - mode: 755
    - unless: test -f /root/ku_repo.sh
  cmd.run:
    - name: /bin/bash /root/ku_repo.sh
    - reuqire:
      - file: kubernetes_repo_yum
  pkg.installed:
    - names:
      - kubelet
      - kubeadm
      - kubectl
    - require:
      - cmd: kubernetes_repo_yum
config_node_modify:
  file.managed:
    - name: /opt/k8s_node_modify.sh
    - source: salt://k8s_node/files/k8s_node_modify.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: /bin/bash -x /opt/k8s_node_modify.sh
    - require:
      - pkg: kubernetes_repo_yum
      - file: config_node_modify

