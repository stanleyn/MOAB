Louvain_Homebrew_Improved=function(Graph,w,resP){
	#This function will use the tragg louvain code in python
	#weight:
		#0: no
		#1: yes
	#resp is the resoltion parameter to use 

library('rPython')

#load in the required libraries we need
	#louvain,igraph,numpy
python.exec('import networkx as nx')
python.exec('import igraph as ig')
python.exec('import louvain')
python.exec('from igraph import *')
python.exec('import numpy as np')

#create an edgelist
EList=get.edgelist(Graph)
EListTemp=mapply(EList,FUN=as.numeric)
EList=matrix(EListTemp,ncol=2)
EList=EList-1

#figure out how many nodes we have
NumNode=vcount(Graph)
python.assign('NumNode',NumNode)

#create an edgelist
python.assign('EList',EList)
#convert e list to array
python.exec('arrayEL=np.asarray(EList)')
#create the graph object from the edgelist
python.exec('g=Graph()')
python.exec('g.add_vertices(NumNode)')
python.exec('g.add_edges(arrayEL)')

#get weight vector
python.assign('WeightVec',E(Graph)$weight)
python.exec('WeightVec=np.asarray(WeightVec)')
python.exec("g.es['weight'] = WeightVec")

meth='RBConfiguration'
python.assign('meth',meth)

w2='weight'
python.assign('w2',w2)

#assign resolution parameter
python.assign('resop',resP)


###for the weighted implementation that we will use
python.exec('part=louvain.find_partition(g,louvain.ModularityVertexPartition,weights=g.es[w2])')

Out=python.get('part.membership')
Out=Out+1
Out
}
