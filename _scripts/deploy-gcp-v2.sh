#!/bin/bash

TOKEN=823077067:AAEaevV1BdvOtWO7rxeXaORA3P6bu1RcQnQ
CHAT_ID=11524381
MESSAGE="Script Terraform Executado com sucesso"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

init_msg="Iniciando VM via TERRAFORM $PWD"
curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$init_msg"

apt-get update
apt-get install -y \
    curl \
    jq \
    docker.io
    git

git clone -b cluster-gcp-v2 https://github.com/dodopontocom/odroid-tensorflow.git
cd odroid-tensorflow
echo $TOKEN > .token
docker build -t tensorflow .

gsutil cp -r gs://odroid-tensorflow/supermarket ./

docker run --rm -v ${PWD}:/home/test -w /home/test/ -u $USER -it tensorflow \
python old_retrain.py \
--bottleneck_dir=./bottlenecks \
--how_many_training_steps 500 \
--model_dir=./inception \
--output_graph=./retrained_graph.pb \
--output_labels=./retrained_labels.txt \
--image_dir=./supermarket

curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$MESSAGE"

bash ./tb-produto.sh 2>&1 /tmp/tb-produto-bot.log
