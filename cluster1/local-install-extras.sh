#!/bin/env bash

which helm || {
    wget https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod +x get-help-3
    ./get-helm-3
    rm get-helm-3
    source <(helm completion bash)
    echo 'source <(helm completion bash)' >> ~/.bashrc
}

helm repo list | grep metrics-server || {
    helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
}

helm --kubeconfig ~/.kube/config status metrics-server -n kube-system || {
    helm upgrade \
        --kubeconfig ~/.kube/config \
        --install metrics-server metrics-server/metrics-server \
        --namespace kube-system
}

# quick test
sleep 20 
kubectl top pod
