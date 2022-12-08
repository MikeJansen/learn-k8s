#!/bin/env bash

echo '---------------------------------------------------------------'
echo 'Step 5 - gen-config-files.sh'
echo '---------------------------------------------------------------'

source ../common/get-vars.sh
pushd ../artifacts/certs
mkdir -p ../configs
rm -f ../configs/*

# worker nodes

for instance in $TF_NODE_LIST; do
  kubectl config set-cluster $K8S_CLUSTER_NAME \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${TF_STATIC_IP_LB}:6443 \
    --kubeconfig=../configs/${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${instance}.pem \
    --client-key=${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=../configs/${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=$K8S_CLUSTER_NAME \
    --user=system:node:${instance} \
    --kubeconfig=../configs/${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=../configs/${instance}.kubeconfig
done

# proxy

{
  kubectl config set-cluster $K8S_CLUSTER_NAME \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${TF_STATIC_IP_LB}:6443 \
    --kubeconfig=../configs/kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy \
    --client-certificate=kube-proxy.pem \
    --client-key=kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=../configs/kube-proxy.kubeconfig

  kubectl config set-context default \
    --cluster=$K8S_CLUSTER_NAME \
    --user=system:kube-proxy \
    --kubeconfig=../configs/kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=../configs/kube-proxy.kubeconfig
}

# controller manager

{
  kubectl config set-cluster $K8S_CLUSTER_NAME \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=../configs/kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.pem \
    --client-key=kube-controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=../configs/kube-controller-manager.kubeconfig

  kubectl config set-context default \
    --cluster=$K8S_CLUSTER_NAME \
    --user=system:kube-controller-manager \
    --kubeconfig=../configs/kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=../configs/kube-controller-manager.kubeconfig
}

# scheduler

{
  kubectl config set-cluster $K8S_CLUSTER_NAME \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=../configs/kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler.pem \
    --client-key=kube-scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=../configs/kube-scheduler.kubeconfig

  kubectl config set-context default \
    --cluster=$K8S_CLUSTER_NAME \
    --user=system:kube-scheduler \
    --kubeconfig=../configs/kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=../configs/kube-scheduler.kubeconfig
}

# admin

{
  kubectl config set-cluster $K8S_CLUSTER_NAME \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=../configs/admin.kubeconfig

  kubectl config set-credentials admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem \
    --embed-certs=true \
    --kubeconfig=../configs/admin.kubeconfig

  kubectl config set-context default \
    --cluster=$K8S_CLUSTER_NAME \
    --user=admin \
    --kubeconfig=../configs/admin.kubeconfig

  kubectl config use-context default --kubeconfig=../configs/admin.kubeconfig
}

# distribute

cd ../configs

for instance in $TF_NODE_LIST; do
  gcloud compute scp ${instance}.kubeconfig kube-proxy.kubeconfig ${instance}:~/
done

for instance in $TF_CP_LIST; do
  gcloud compute scp admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig ${instance}:~/
done

popd
