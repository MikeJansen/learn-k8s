#!/bin/env bash

source ../common/get-vars.sh

etcd_servers=()
for address in $TF_CP_IPS; do
    etcd_servers+=("https://${address}:2379")
done
etcd_servers=$(IFS=, ; echo "${etcd_servers[*]}")

index=0
for address in $TF_CP_IPS; do
    instance=cp${index}

    gcloud compute scp cp-bootstrap-control-plane.sh $instance:~/
    gcloud compute ssh $instance -- /bin/bash -c "cd ~; chmod +x cp-bootstrap-control-plane.sh; ./cp-bootstrap-control-plane.sh $address $TF_STATIC_IP_LB '$etcd_servers'"

    index=$((index+1))
done

for instance in $TF_CP_LIST; do
    gcloud compute ssh $instance -- sudo systemctl start etcd
done
