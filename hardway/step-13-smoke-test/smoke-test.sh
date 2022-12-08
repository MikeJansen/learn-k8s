#!/bin/env bash


echo '---------------------------------------------------------------'
echo 'Step 13 - Smoke Test'
echo '---------------------------------------------------------------'

# test encryption

kubectl create secret generic kubernetes-the-hard-way \
  --from-literal="mykey=mydata"

gcloud compute ssh controller-0 \
  --command "sudo ETCDCTL_API=3 etcdctl get \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem\
  /registry/secrets/default/kubernetes-the-hard-way | hexdump -C"

# test deployments

kubectl create deployment nginx --image=nginx
kubectl get pods -l app=nginx

# test port forwarding

POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath="{.items[0].metadata.name}")
kubectl port-forward $POD_NAME 8080:80 &
K8S_PID=$!
curl --head http://127.0.0.1:8080
kill -9 $K8S_PID

# test logs
kubectl logs $POD_NAME

# test expose service
  
kubectl expose deployment nginx --port 80 --type NodePort
NODE_PORT=$(kubectl get svc nginx \
  --output=jsonpath='{range .spec.ports[0]}{.nodePort}')
gcloud compute firewall-rules create kubernetes-the-hard-way-allow-nginx-service \
  --allow=tcp:${NODE_PORT} \
  --network network
EXTERNAL_IP=$(gcloud compute instances describe node0 \
  --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')