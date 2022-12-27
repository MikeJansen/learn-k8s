#!/bin/env bash

gcloud compute instances start cp0 node0
sleep 5
source create-all.sh
gcloud compute ssh cp0 -- /bin/env bash -c "cd ~; kubectl uncordon cp0; kubectl uncordon node0"
