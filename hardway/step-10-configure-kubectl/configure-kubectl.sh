#!/bin/env bash

echo '---------------------------------------------------------------'
echo 'Step 10 - Configure kubectl'
echo '---------------------------------------------------------------'

source ../common/get-vars.sh

pushd ../artifacts/certs

{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${TF_STATIC_IP_LB}:6443

  kubectl config set-credentials admin \
    --client-certificate=admin.pem \
    --client-key=admin-key.pem

  kubectl config set-context kubernetes-the-hard-way \
    --cluster=kubernetes-the-hard-way \
    --user=admin

  kubectl config use-context kubernetes-the-hard-way
}

popd
