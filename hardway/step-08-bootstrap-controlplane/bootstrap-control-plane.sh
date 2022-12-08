#!/bin/env bash

echo '---------------------------------------------------------------'
echo 'Step 8 - bootstrap-control-plane.sh'
echo '---------------------------------------------------------------'

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
    gcloud compute ssh $instance -- /bin/bash -c "cd ~; chmod +x cp-bootstrap-control-plane.sh; ./cp-bootstrap-control-plane.sh $address $TF_STATIC_IP_LB '$TF_POD_CIDR' '$TF_SERVICE_CIDR' '$etcd_servers'"

    index=$((index+1))
done

gcloud compute scp cp0-bootstrap-rbac.sh cp0:~/
gcloud compute ssh cp0 -- /bin/bash -c "cd ~; chmod +x cp0-bootstrap-rbac.sh; ./cp0-bootstrap-rbac.sh"
