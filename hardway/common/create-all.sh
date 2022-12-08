#!/bin/env bash

pushd ../step-03-provisioning

terraform init
terraform apply

# let the compute settle to avoid possible SSH key race condition
sleep 10

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

popd