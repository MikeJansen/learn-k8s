#!/bin/env bash

K_JOIN_TOKEN=$(sudo kubeadm token create)
K_JOIN_HASH=$(sudo openssl x509 -pubkey \
    -in /etc/kubernetes/pki/ca.crt | 
    openssl rsa -pubin -outform der 2>/dev/null |
    openssl dgst -sha256 -hex |
    sed 's/^.* //')
echo "export K_JOIN_TOKEN=$K_JOIN_TOKEN"
echo "export K_JOIN_HASH=$K_JOIN_HASH"
