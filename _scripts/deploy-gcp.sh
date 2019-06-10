#!/bin/bash

sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
	jq

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER

git clone https://github.com/dodopontocom/odroid-tensorflow.git
PROJECT=~/odroid-tensorflow
TB_TOKEN=<TELEGRAM_TOKEN>
echo $TB_TOKEN > $PROJECT/.token
cd $PROJECT
sudo docker build -t tensorflow . && ./tb-produto.sh
