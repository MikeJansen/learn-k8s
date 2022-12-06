#!/bin/env bash

source ./get-vars.sh
gcloud compute instances start $TF_COMPUTE_LIST
