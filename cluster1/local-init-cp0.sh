#!/bin/env bash

source get-vars.sh

# run locally initializes the first control plane

# init base on new worker node
gcloud compute scp k_vars.sh remote-vars.sh remote-init-all.sh remote-init-cp0.sh cp0:~/
gcloud compute ssh cp0 -- /bin/bash -c 'cd ~; chmod +x remote*.sh ; ./remote-init-all.sh ; ./remote-init-cp0.sh'

gcloud compute scp root@cp0:/etc/kubernetes/admin.conf .
export K_CA_CERT=$(yq '.clusters[0].cluster.certificate-authority-data' admin.conf)
export K_USER_CERT=$(yq '.users[0].user.client-certificate-data' admin.conf)
export K_USER_KEY=$(yq '.users[0].user.client-key-data' admin.conf)
yq '(.clusters[]|select(.name=="kubernetes").cluster.certificate-authority-data) = env(K_CA_CERT) | 
    (.clusters[]|select(.name=="kubernetes").cluster.server) = "https://" + env(K_STATIC_IP_LB) + ":6443" |
    (.clusters[]|select(.name=="kubernetes").cluster.tls-server-name) = "k8scp" |
    (.users[]|select(.name=="kubernetes-admin").user.client-certificate-data) = env(K_USER_CERT) |
    (.users[]|select(.name=="kubernetes-admin").user.client-key-data) = env(K_USER_KEY)' ~/.kube/config > config
cp ~/.kube/config ~/.kube/config-$(date +%Y%m%d%H%M%S)
cp config ~/.kube/config
rm config admin.conf

for csr in $(kubectl get csr -o yaml | 
    yq '.items[] | 
            select( .spec.username=="system:node:cp0" and 
                      ( 
                        ( has("status.conditions") | not ) or 
                        (.status.conditions[] | select(.type=="Approved") | length)==0
                      )
                  ) | .metadata.name');
do
    kubectl certificate approve $csr
done

