#!/bin/env bash

source get-vars.sh
gcloud compute instances start $TF_COMPUTE_LIST haproxy0
sleep 20
source create-all.sh
sleep 5
kubectl uncordon $TF_CP_LIST; kubectl uncordon $TF_NODE_LIST
