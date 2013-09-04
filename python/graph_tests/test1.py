#!/usr/bin/python
# Copyright (C) 2009 Raphael Champeimont
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

import igraph

def g(x):
    print "I am a dying graph."
igraph.Graph.__del__ = g


#g1 = igraph.Graph.Read("simple.lgl", format="lgl")
#print g1, type(g1)
#g2 = igraph.Graph.Read("graph_a.ncol", format="ncol", directed=False)
#print g2, type(g2)
#graphs = [('simple.lgl', g1), ('graph_a.ncol', g2)]
print "Generating graph..."
gr = igraph.Graph.Growing_Random(10**5, 100)
print gr
graphs = [('gr', gr)]

for (graph_name, g) in graphs:
    #g.write("%s.svg" % graph_name, format="svg", layout="fruchterman_reingold")
    print "Computing connected components..."
    vc = g.clusters()
    #print type(vc)
    #print vc

    for i in xrange(0,len(vc)):
        print "CONNECTED COMPONENT #%d" % i
        cc = vc.subgraph(i)
        print cc
        #print cc, type(cc)
        #cc.write("%s_cc%d.svg" % (graph_name,i), format="svg", layout="fruchterman_reingold")
        for vertex in cc.vs:
            #print "cc=%d vertex_name=%s" % (i, vertex["name"])
            pass
