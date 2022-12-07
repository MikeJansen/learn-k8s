# distribute certs

source ../common/get-vars.sh
pushd ../artifacts/certs

for instance in $TF_NODE_LIST; do
    gcloud compute scp \
      ca.pem ${instance}-key.pem \
      ${instance}.pem \
      ${instance}:~/
done

for instance in $TF_CP_LIST; do
    gcloud compute scp \
      ca.pem ca-key.pem \
      kubernetes-key.pem \
      kubernetes.pem \
      service-account-key.pem \
      service-account.pem \
      ${instance}:~/
done

popd