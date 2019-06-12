FROM tensorflow/tensorflow

ENV WORKING_DIRECTORY /home/tensorflowEx
ENV SCRIPTS_DIRECTORY /home/tensorflowEx/scripts
ENV GOOGLE_BUCKET_FOLDER supermarket

ENV CLOUD_SDK_REPO cloud-sdk-xenial
ENV RETRAIN_ARGS --bottleneck_dir=./bottlenecks \
                 --how_many_training_steps 500 \
                 --model_dir=./inception \
                 --output_graph=./retrained_graph.pb \
                 --output_labels=./retrained_labels.txt \
                 --image_dir=./$GOOGLE_BUCKET_FOLDER

ENV PIP_14 "https://files.pythonhosted.org/packages/88/bd/77bac5a06d73c7ee8287d608607a118fd53eb3479e413687be205d0a75f0/tensorflow-1.14.0rc0-cp27-cp27mu-manylinux1_x86_64.whl"

RUN apt-get update && \
    apt-get install -y wget curl apt-utils

RUN echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update
RUN apt-get install -y google-cloud-sdk

RUN wget $PIP_14
RUN python -m pip install tensorflow-1.14.0rc0-cp27-cp27mu-manylinux1_x86_64.whl

RUN pip install tensorflow-hub && \
    pip install matplotlib && \
    pip install Pillow

RUN mkdir -p $SCRIPTS_DIRECTORY
WORKDIR $SCRIPTS_DIRECTORY

ADD account.json /tmp/account.json
RUN gcloud auth activate-service-account --key-file=/tmp/account.json
RUN gsutil cp -r gs://odroid-tensorflow/supermarket $SCRIPTS_DIRECTORY
RUN rm -vfr /tmp/account.json
RUN rm -vfr ./account.json

ADD . $WORKING_DIRECTORY

RUN /usr/bin/python old_retrain.py $RETRAIN_ARGS
