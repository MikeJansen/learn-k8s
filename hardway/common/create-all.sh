#!/bin/env bash

source gcloud-login.sh

pushd ../step-03-provisioning

terraform init
terraform apply -var project_id=$(gcloud config get project)

cd ../common
source get-vars.sh
if [[ $TF_PROJECT_ID == '' ]]; then
    echo 'Terraform did not apply successfully.'
    exit
fi

gcloud config set compute/region $TF_REGION
gcloud config set compute/zone $TF_ZONE

# let the compute settle to avoid possible SSH key race condition
sleep 10

touch delete.me
gcloud compute scp --force-key-file-overwrite delete.me cp0:~/ < /dev/null
rm delete.me

cd ../step-04-certs
./gen-certs.sh

cd ../step-05-config-files
./gen-config-files.sh

cd ../step-06-encryption
./gen-encrypt.sh

cd ../step-07-bootstrap-etcd
./bootstrap-etcd.sh

cd ../step-08-bootstrap-controlplane
./bootstrap-control-plane.sh

cd ../step-09-bootstrap-worker-nodes
./bootstrap-worker-nodes.sh

cd ../step-10-configure-kubectl
./configure-kubectl.sh

cd ../step-12-deploy-coredns
./deploy-coredns.sh

cd ../step-13-smoke-test
./smoke-test.sh

popd