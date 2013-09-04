#!/usr/bin/env python
# coding=utf-8

# Under GNU GPLv2 or later
 
import igraph
import sys

#def g(x):
#    print "I am a dying graph."
#igraph.Graph.__del__ = g
 
# On créé foo par SELECT * FROM bestortho
# On a préalablement récupéré les données de foo avec 'cut' pour créer arretes
 
print "loading graph..."
 
gr=igraph.Graph.Read("donnees/arretes.test",format='ncol',directed=False)
#gr=igraph.Graph.Read("graph_a.ncol",format='ncol',directed=False)
print gr
 
print "graphe créé\n"
 
groupes=gr.clusters()
del gr
 
print "groupes créés\n"
 
 
# A partir de groupes récuperer les sous graphes
 
filout = open("groupes", "w")

print "There are %d connected components." % len(groupes)

for i in xrange(0,len(groupes),1):
    print "Connected component #%d" % i
    groupe=groupes.subgraph(i)
#    print groupe
    for vertex in groupe.vs:
        filout.write("%d\t%s" % (i, vertex["name"]))
        filout.write("\n")
filout.close()
