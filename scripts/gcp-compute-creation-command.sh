#!/bin/bash
name=$1
if [[ -n $name ]]; then
    gcloud compute instances create $name --zone us-central1-a --machine-type f1-micro --tags http-server --metadata-from-file startup-script='scripts/deploy-gcp.sh'
fi
