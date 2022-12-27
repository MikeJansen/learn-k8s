#!/bin/env bash

gcloud compute ssh cp0 -- /bin/env bash -c "cd ~; kubectl drain node0 --ignore-daemonsets; kubectl drain cp0 --ignore-daemonsets"
gcloud compute instances stop cp0 node0
