#!/bin/env bash

#---------------------------------------------------------------------------------------
# WORKER INIT
#---------------------------------------------------------------------------------------

source k_vars.sh
source k_vars_join.sh

sudo kubeadm join \
    --token ${K_JOIN_TOKEN} \
    k8scp:6443 \
    --discovery-token-ca-cert-hash sha256:${K_JOIN_HASH}
