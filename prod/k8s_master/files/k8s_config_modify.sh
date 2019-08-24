#!/bin/bash
swapoff -a
sed -i 's/net.bridge.bridge-nf-call-ip6tables = 0/net.bridge.bridge-nf-call-ip6tables = 1/' /usr/lib/sysctl.d/00-system.conf
sed -i 's/net.bridge.bridge-nf-call-iptables = 0/net.bridge.bridge-nf-call-iptables = 1/' /usr/lib/sysctl.d/00-system.conf
echo 'Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"' >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sed -i 's/Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"/Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=cgroupfs"/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sed -i  's%Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin"%#Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin"%' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
systemctl enable kubelet && systemctl start kubelet
init_kubr=`kubeadm init --kubernetes-version=1.10.0 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors all` 
mkdir -p /root/.kube 
cp -i /etc/kubernetes/admin.conf /root/.kube/config 
chown $(id -u):$(id -g) /root/.kube/config
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml
systemctl daemon-reload
systemctl restart kubelet
