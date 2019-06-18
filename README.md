[![CircleCI](https://circleci.com/gh/dodopontocom/odroid-tensorflow/tree/develop.svg?style=svg)](https://circleci.com/gh/dodopontocom/odroid-tensorflow/tree/develop)
[![Docker Pulls](https://img.shields.io/docker/pulls/rodolfoneto/tensorflow-retrained-experience.svg)](https://hub.docker.com/r/rodolfoneto/tensorflow-retrained-experience/)

# odroid-tensorflow

Este repositório tem o objetivo de dar suporte ao desenvolvimento de um bot para Telegram usando também o Tensorflow. Links abaixo  

https://github.com/shellscriptx/shellbot/wiki  
https://core.telegram.org/bots  
https://www.tensorflow.org/  

#

## Pipeline current workFlow  
- [x] Github development and branching  
- [x] Circle-ci active and dynamic integration [details](.circleci/README.md)
- [x] Python scripts  
- [x] Tensorflow python modules and more  
- [x] Tensorflow training scripts and more  
- [x] Upload latest docker image to dockerhub  
- [x] Perform a simple image recognition test and send result via Telegram Bot    
- [x] Startup Terraform flow to deploy the solution to GCP  
- [x] Run the Telegram Bot on daemon mode from GCP instance  

## Todo (Regarding the Pipeline)  

- [ ] Develop Terraform 'destroy' flow for maintainance  
- [ ] Improve Terraform scripts to turn the Bot off during the night and turn it on again in the morning to save GCP hours (money)    
- [ ] Improve Terraform scripts to better scale the instance up or down  
- [ ] Check the possibility of using GCP Cluster instead of GCP compute instance (VMs)  
- [ ] Improve startup metada script [details](Terraform/README-improvements.md)

![Pipeline workFlow](images/01_dev_flow.jpg)
