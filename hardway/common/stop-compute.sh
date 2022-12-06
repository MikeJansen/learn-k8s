#!/bin/env bash

source ./get-vars.sh
gcloud compute instances stop $TF_COMPUTE_LIST
