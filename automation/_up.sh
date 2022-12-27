#!/bin/env bash

source gcloud-login.sh

pushd terraform
terraform init
terraform apply --auto-approve -var project_id=$(gcloud config get project) || exit 1
popd

source gen-vars.sh


