#!/bin/env bash

source ../common/get-vars.sh

index=0
cluster_list=()
for address in $TF_CP_IPS; do
    instance=cp${index}
    cluster_list+=("${instance}=https://${address}:2380")
    index=$((index+1))
done

initial_cluster=$(IFS=, ; echo "${cluster_list[*]}")

index=0
for address in $TF_CP_IPS; do
    instance=cp${index}

    gcloud compute scp cp-bootstrap-etcd.sh $instance:~/
    # This could be async so they run in parallel
    gcloud compute ssh $instance -- /bin/bash -c "cd ~; chmod +x cp-bootstrap-etcd.sh; ./cp-bootstrap-etcd.sh $address '$initial_cluster'"

    index=$((index+1))
done

for instance in $TF_CP_LIST; do
    gcloud compute ssh $instance -- sudo systemctl start etcd
done

gcloud compute ssh cp0 -- sudo ETCDCTL_API=3 etcdctl member list \
    --endpoints=https://127.0.0.1:2379 \
    --cacert=/etc/etcd/ca.pem \
    --cert=/etc/etcd/kubernetes.pem \
    --key=/etc/etcd/kubernetes-key.pem