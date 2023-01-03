#!/bin/env bash

source get-vars.sh

# run locally

# init base on new worker node
gcloud compute scp k_vars.sh remote-vars.sh remote-init-all.sh remote-init-worker.sh worker0:~/
gcloud compute ssh worker0 -- /bin/bash -c 'cd ~; chmod +x remote-init-all.sh ; ./remote-init-all.sh'

# get join info from cp0
gcloud compute scp remote-cp0-join-worker.sh cp0:~/
gcloud compute ssh cp0 -- /bin/bash -c 'cd ~; chmod +x remote-cp0-join-worker.sh; ./remote-cp0-join-worker.sh' > k_vars_join.sh
dos2unix k_vars_join.sh # no idea why this is getting CRLF

# do join on worker
gcloud compute scp k_vars_join.sh worker0:~/
gcloud compute ssh worker0 -- /bin/bash -c 'cd ~; chmod +x remote-init-worker.sh; ./remote-init-worker.sh'

for csr in $(kubectl get csr -o yaml | 
    yq '.items[] | 
            select( .spec.username=="system:node:worker0" and 
                    ( 
                        ( has("status.conditions") | not ) or 
                        (.status.conditions[] | select(.type=="Approved") | length)==0
                    )
                ) | .metadata.name');
do
    kubectl certificate approve $csr
done

# quick test.  do DNS lookup on service and call service via load balancer. 
# if those succeed, networking, dns, and general functionality of cluster OK
sleep 10
kubectl create deploy nginx --image nginx
kubectl expose deploy/nginx --type NodePort --port 80
kubectl run -it --rm --image busybox --restart Never test -- nslookup nginx
K_TEST_NODEPORT=$(kubectl get svc/nginx -o yaml|yq '.spec.ports[0].nodePort')
curl http://${K_STATIC_IP_LB}:${K_TEST_NODEPORT}
kubectl delete all -l app=nginx




