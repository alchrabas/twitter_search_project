# -*- coding: utf-8 -*-
#!/usr/bin/env python

from graphviz import Digraph
import csv
from queue import Queue

def parse_csv(csv_file):
  csv_reader = csv.reader(open(csv_file), dialect=csv.excel)
  return {str(key):value for [value, key] in csv_reader}

def draw_graph(centroid, graph, g):
  for key in graph:
    g.node(key)
  large_set = Queue()
  large_set.put(centroid)
  visited_from_graph = {}
  while not large_set.empty():
    key = large_set.get()
    if key in graph and key not in visited_from_graph:
      visited_from_graph[key] = True
      for keyword in graph[key]:
        g.edge(key, keyword)
        large_set.put(keyword)

styles = {
    'graph': {
        'fontsize': '16',
        'fontcolor': 'black',
        'bgcolor': 'white',
		'layout': 'sfdp',
		'overlap':'false',
    },
    'nodes': {
        'fontname': 'Helvetica',
        'color': 'black',
    },
    'edges': {
        'color': 'black',
        'arrowhead': 'open',
        'fontname': 'Courier',
        'fontsize': '12',
        'fontcolor': 'gray',
    }
}

def apply_styles(graph, styles):
    graph.graph_attr.update(
        ('graph' in styles and styles['graph']) or {}
    )
    graph.node_attr.update(
        ('nodes' in styles and styles['nodes']) or {}
    )
    graph.edge_attr.update(
        ('edges' in styles and styles['edges']) or {}
    )
    return graph

def main():
  dataset = {
      u'users' : parse_csv('data/to_graphviz.csv')
  }
  g = Digraph(format='svg')
  for key in dataset:
    draw_graph(key, dataset, g)
    g = apply_styles(g, styles)
    g.render('graph')

if __name__ == '__main__':
    main()

