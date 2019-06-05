FROM tensorflow/tensorflow

RUN pip install -U tensorflow==1.14.0rc0 && \
    pip install tensorflow-hub && \
    pip install matplotlib && \
    pip install Pillow

ADD tensor-example.py /home/

CMD ["/usr/bin/python", "/home/tensor-example.py]

#https://www.tensorflow.org/alpha/tutorials/images/hub_with_keras
