#!/usr/bin/env python

from __future__ import absolute_import, division, print_function, unicode_literals
import matplotlib
matplotlib.use('Agg')
import matplotlib.pylab as plt
import tensorflow as tf
import tensorflow_hub as hub
from tensorflow.keras import layers
import numpy as np
import PIL.Image as Image
import sys
import time

start = time.time()

URL = sys.argv[1]

tf.enable_eager_execution()

classifier_url ="https://tfhub.dev/google/tf2-preview/mobilenet_v2/classification/2" #@param {type:"string"}

IMAGE_SHAPE = (224, 224)
classifier = tf.keras.Sequential([
    hub.KerasLayer(classifier_url, input_shape=IMAGE_SHAPE+(3,))
])

#grace_hopper = tf.keras.utils.get_file(URL)
#grace_hopper = tf.keras.utils.get_file('image.jpg','https://storage.googleapis.com/download.tensorflow.org/example_images/grace_hopper.jpg')
grace_hopper = Image.open(URL).resize(IMAGE_SHAPE)
grace_hopper

grace_hopper = np.array(grace_hopper)/255.0
grace_hopper.shape

result = classifier.predict(grace_hopper[np.newaxis, ...])
result.shape

predicted_class = np.argmax(result[0], axis=-1)
predicted_class

labels_path = tf.keras.utils.get_file('ImageNetLabels.txt','https://storage.googleapis.com/download.tensorflow.org/data/ImageNetLabels.txt')
imagenet_labels = np.array(open(labels_path).read().splitlines())

plt.imshow(grace_hopper)
plt.axis('off')

predicted_class_name = imagenet_labels[predicted_class]
#_ = print("Prediction: |" + predicted_class_name.title())

def return_print():
    return predicted_class_name.title()

print(return_print())

def elapsed_function():
    done = time.time()
    slapsed = done - start
    return slapsed

print(elapsed_function())
