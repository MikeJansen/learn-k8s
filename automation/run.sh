#!/bin/env bash

IMAGE_NAME=k8s-automated
SERVICE_ACCOUNT=$IMAGE_NAME
ACCOUNT_KEY=${IMAGE_NAME}.json
PROJECT_ID=$(gcloud config get project)

pushd docker
if [ -z ${WSL_DISTRO_NAME+x} ]; then
    docker build -t $IMAGE_NAME .
else
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe \
        -c "docker build -t $IMAGE_NAME ."
fi
popd

gcloud services enable \
    iam.googleapis.com \
    compute.googleapis.com
gcloud iam service-accounts create \
    $SERVICE_ACCOUNT \
    --display-name 'K8S Automated'
ACCOUNT_ID=$(gcloud iam service-accounts list \
                --filter="email ~ ^${SERVICE_ACCOUNT}" \
                --format='value(email)')
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$ACCOUNT_ID \
    --role=roles/owner
gcloud iam service-accounts keys create $ACCOUNT_KEY --iam-account $ACCOUNT_ID

docker run -it --rm \
    --mount type=bind,src=$PWD,dst=/var/task \
    --env CLOUDSDK_CORE_PROJECT=$PROJECT_ID \
    --env K_ACCOUNT_KEY=$ACCOUNT_KEY \
    $IMAGE_NAME \
    /bin/bash -c "./_$1.sh"

gcloud iam service-accounts delete $ACCOUNT_ID --quiet
rm $ACCOUNT_KEY
