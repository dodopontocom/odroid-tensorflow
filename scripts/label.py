#!/usr/bin/env python
# coding: utf8

import tensorflow as tf, sys, time

start = time.time()
retrained_labels = "/home/tensorflowEx/scripts/retrained_labels.txt"
retrained_graph = "/home/tensorflowEx/scripts/retrained_graph.pb"

image_path = sys.argv[1]
image_data = tf.gfile.FastGFile(image_path, 'rb').read()

label_lines = [line.rstrip() for line
        in tf.io.gfile.GFile(retrained_labels)]

with tf.gfile.FastGFile(retrained_graph, 'rb') as f:
        graph_def = tf.compat.v1.GraphDef()
        graph_def.ParseFromString(f.read())
        _ = tf.import_graph_def(graph_def, name='')

with tf.compat.v1.Session() as sess:
        softmax_tensor = sess.graph.get_tensor_by_name('final_result:0')
        predictions = sess.run(softmax_tensor, {'DecodeJpeg/contents:0': image_data})
        #predictions = sess.run(softmax_tensor, {'Placeholder:0': image_data})
        top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]

        for node_id in top_k:
                human_string = label_lines[node_id]
                score = predictions[0][node_id]
                if score >= 0.8:
                        print(human_string)
                        print(score)
                        break
                else:
                        print("---")
                        print("Padrão baixo. Tente enviar outra imagem...")

def elapsed_function():
    done = time.time()
    slapsed = done - start
    return slapsed

print(elapsed_function())