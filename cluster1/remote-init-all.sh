#!/bin/env bash

#---------------------------------------------------------------------------------------
# ALL NODES INIT
#---------------------------------------------------------------------------------------

source k_vars.sh
source remote-vars.sh

# apt update and basic installs
sudo apt update; sudo apt upgrade -y

sudo apt install curl apt-transport-https git wget gnupg2 \
    software-properties-common ca-certificates uidmap -y

sudo wget https://github.com/mikefarah/yq/releases/download/v4.30.6/yq_linux_amd64 \
    -O /usr/bin/yq
sudo chmod +x /usr/bin/yq

#swapoff -a

# kernel networking changes
sudo modprobe overlay; sudo modprobe br_netfilter
cat << EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

# conainterd
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt install containerd -y

# kubernetes installs, setup repo and install

echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | 
    sudo tee -a /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt update
sudo apt install -y kubeadm=$K8S_APT_VERSION kubelet=$K8S_APT_VERSION kubectl=$K8S_APT_VERSION
sudo apt-mark hold kubectl kubeadm kubelet

echo 'source <(kubeadm completion bash)' >> ~/.bashrc

# API hostname alias

echo "$K_CP0_IP k8scp" | sudo tee -a /etc/hosts

