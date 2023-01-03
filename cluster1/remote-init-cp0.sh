#!/bin/env bash

#---------------------------------------------------------------------------------------
# CP0 INIT
#---------------------------------------------------------------------------------------

source k_vars.sh
source remote-vars.sh

cat << EOF > kubeadm-config.yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: $K8S_VERSION
controlPlaneEndpoint: "k8scp:6443"
networking:
  podSubnet: $K_POD_CIDR
  serviceSubnet: $K_SERVICE_CIDR
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
serverTLSBootstrap: true
EOF

sudo kubeadm init --config=kubeadm-config.yaml --upload-certs | tee kubeadm-init.out

mkdir -p ~/.kube
sudo cp -i /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

# calico
wget https://docs.projectcalico.org/manifests/calico.yaml

# not sure this was actually needed -- read on SO that Calico gets the value from kubeadm
yq '(
        select(.kind=="DaemonSet" and .metadata.name=="calico-node") |
        .spec.template.spec.containers[] |
        select(.name=="calico-node") |
        .env
    ) 
    += [{"name": "CALICO_IPV4POOL_CIDR", "value": env(K_POD_CIDR)}]' \
    calico.yaml > calico2.yaml
kubectl apply -f calico2.yaml

