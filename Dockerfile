FROM tensorflow/tensorflow

ENV PIP_14 "https://files.pythonhosted.org/packages/88/bd/77bac5a06d73c7ee8287d608607a118fd53eb3479e413687be205d0a75f0/tensorflow-1.14.0rc0-cp27-cp27mu-manylinux1_x86_64.whl"

RUN apt-get update && \
    apt-get install -y wget

RUN wget $PIP_14
RUN python -m pip install tensorflow-1.14.0rc0-cp27-cp27mu-manylinux1_x86_64.whl

RUN pip install tensorflow-hub && \
    pip install matplotlib && \
    pip install Pillow

ADD tensor-example.py /home/

CMD ["/usr/bin/python", "/home/tensor-example.py"]

#https://www.tensorflow.org/alpha/tutorials/images/hub_with_keras
