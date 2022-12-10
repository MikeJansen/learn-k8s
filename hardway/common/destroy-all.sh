#!/bin/env bash

source gcloud-login.sh

pushd ../step-03-provisioning

terraform destroy -var project_id=$(gcloud config get project)

cd ..
rm -rf artifacts

popd
