#!/bin/bash
swapoff -a
sed -i 's/Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"/Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl enable kubelet && systemctl start kubelet
kubeadm join 192.168.147.191:6443 --token wsd4sq.fbo1e8xwmvobrlrc --discovery-token-ca-cert-hash sha256:54305f8258ade75d695630b08db10f5bb43420566ed8bb46289fbc1c9e41ed7a
