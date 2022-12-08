#!/bin/env bash

echo '---------------------------------------------------------------'
echo 'Step 9 - bootstrap-w.sh'
echo '---------------------------------------------------------------'

source ../common/get-vars.sh

etcd_servers=()
for address in $TF_CP_IPS; do
    etcd_servers+=("https://${address}:2379")
done
etcd_servers=$(IFS=, ; echo "${etcd_servers[*]}")

index=0
for address in $TF_NODE_IPS; do
    instance=node${index}

    gcloud compute scp node-bootstrap-worker-nodes.sh $instance:~/
    gcloud compute ssh $instance -- /bin/bash -c "cd ~; chmod +x node-bootstrap-worker-nodes.sh; ./node-bootstrap-worker-nodes.sh $address $TF_STATIC_IP_LB '$TF_POD_CIDR' '$TF_SERVICE_CIDR' '$etcd_servers' $TF_CLUSTER_DNS_IP"

    index=$((index+1))
done
