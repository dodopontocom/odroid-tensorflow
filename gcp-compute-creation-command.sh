#!/bin/bash
gcloud compute instances create vm-tensorflow-1 --zone us-central1-a --machine-type f1-micro --tags http-server --metadata-from-file startup-script='../_scripts/deploy-gcp.sh'