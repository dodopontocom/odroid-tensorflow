#!/bin/bash
name=$1
if [[ -n $name ]]; then
    gcloud compute instances create $name --zone us-central1-a --image ubuntu-1804-bionic-v20190530 --machine-type f1-micro --tags http-server --metadata-from-file startup-script='_scripts/deploy-gcp.sh'
fi