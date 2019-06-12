#!/bin/bash

TOKEN=836946740:AAHC7FPaJMZU7fN34MwJ9Y6NzIWO-tDsRu8
CHAT_ID=11504381
MESSAGE="Script Terraform Executado com sucesso"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

init_msg="Iniciando VM via TERRAFORM $PWD"
curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$init_msg"

apt-get update
apt-get install -y docker.io jq curl git

git clone -b develop https://github.com/dodopontocom/odroid-tensorflow.git
curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$MESSAGE"
bash ./odroid-tensorflow/scripts/tb-produto.sh $TOKEN > /tmp/tb-produto-bot.log 2>&1
