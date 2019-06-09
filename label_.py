#!/usr/bin/env python
# coding: utf8

import tensorflow as tf, sys

image_path = sys.argv[1]
image_data = tf.gfile.FastGFile(image_path, 'rb').read()

label_lines = [line.rstrip() for line
        in tf.gfile.GFile("/home/tensor-photos/retrained_labels.txt")]

with tf.gfile.FastGFile("/home/tensor-photos/retrained_graph.pb", 'rb') as f:
        graph_def = tf.GraphDef()
        graph_def.ParseFromString(f.read())
        _ = tf.import_graph_def(graph_def, name='')

with tf.Session() as sess:
        softmax_tensor = sess.graph.get_tensor_by_name('final_result:0')
        #predictions = sess.run(softmax_tensor)
        predictions = sess.run(softmax_tensor, {'DecodeJpeg/contents:0': image_data})
        #predictions = sess.run(softmax_tensor, {'Placeholder:0': image_data})
        top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]

        for node_id in top_k:
                human_string = label_lines[node_id]
                score = predictions[0][node_id]
                print(human_string, score)
                if score >= 0.8:
                        print(human_string)
                        print(score)
                        exit()
                else:
                        print("---")
                        print("Padrão baixo. Tente enviar outra imagem...")