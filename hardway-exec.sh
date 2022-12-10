#!/bin/env bash

pushd hardway/docker

if [[ $WSL_DISTRO_NAME == '' ]]; then
    docker build -t hardway .
else
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe \
        -c "docker build -t hardway ."
fi

popd 

gcloud services enable iam.googleapis.com compute.googleapis.com
gcloud iam service-accounts create k8s-hardway --display-name "Kubernetes the Hard Way"
account_id=$(gcloud iam service-accounts list --filter="email ~ ^k8s-hardway" --format='value(email)')
gcloud iam service-accounts keys create k8s-hardway.json --iam-account $account_id
gcloud projects add-iam-policy-binding $(gcloud config get project) --member=serviceAccount:$account_id --role=roles/owner

docker run -it --rm \
    --mount type=bind,src=$PWD,dst=/var/task \
    --env CLOUDSDK_CORE_PROJECT=$(gcloud config get project) \
    hardway \
    /bin/bash -c $1

account_id=$(gcloud iam service-accounts list --filter="email ~ ^k8s-hardway" --format='value(email)')
gcloud iam service-accounts delete $account_id --quiet
rm k8s-hardway.json
