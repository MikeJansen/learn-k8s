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
./gen-ecnrypt.sh

cd ../step-07-bootstrap-etcd
./bootstrap-etcd.sh

popd