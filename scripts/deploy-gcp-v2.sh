#!/bin/bash
  
TOKEN=${TELEGRAM_TOKEN}
CHAT_ID=${NOTIFICATION_IDS}

MESSAGE="Script Terraform Executado com sucesso"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

init_msg="Iniciando VM via TERRAFORM $PWD"
curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$init_msg"

apt-get update
apt-get install -y docker.io jq curl git

docker pull rodolfoneto/tensorflow-retrained-experience

git clone -b develop https://github.com/dodopontocom/odroid-tensorflow.git
curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$MESSAGE"
bash ./odroid-tensorflow/scripts/tb-produto.sh $TOKEN > /tmp/tb-produto-bot.log 2>&1
