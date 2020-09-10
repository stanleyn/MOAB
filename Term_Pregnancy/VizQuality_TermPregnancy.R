library('igraph')
library('largeVis')
library('foreach')
library('doParallel')

Raw=readRDS('Term_Pregnancy/data/AllX_NoDup')
PointLab=readRDS('Term_Pregnancy/data/nodelabs_NoDup')
source('MOAB_main/CompCorTest.R')

#tSNE embedding
Tolo=readRDS('Term_Pregnancy/Embeddings/tSNE_noDup')
graph=readRDS('Term_Pregnancy/Layout_Graph_Preg7/tSNE_graph')
tSNE=CompCorTest(Raw,graph)[,1]
print('tSNE')
print(sum(tSNE))

#umap
Tolo=readRDS('Term_Pregnancy/Embeddings/UMAP_noDup')
TGraph=readRDS('Term_Pregnancy/Layout_Graph_Preg7/umap')
graph=graph.adjacency(TGraph,mode='undirected',weighted=TRUE)
umap=CompCorTest(Raw,graph)[,1]
print('umap')
print(sum(umap))


#largeVis
Tolo=readRDS('Term_Pregnancy/Embeddings/LargeVis_noDup')
TGraph=readRDS('Term_Pregnancy/Layout_Graph_Preg7/LV')
graph=graph.adjacency(TGraph,mode='undirected',weighted=TRUE)
LV=CompCorTest(Raw,graph)[,1]
print('largeVis')
print(sum(LV))

#Lamp
Tolo=readRDS('Term_Pregnancy/Embeddings/Lamp')
TGraph=readRDS('Term_Pregnancy/Layout_Graph_Preg7/Lamp')
graph=graph.adjacency(TGraph,mode='undirected',weighted=TRUE)
Lamp=CompCorTest(Raw,graph)[,1]
print(sum(Lamp))


#triMap
Tolo=readRDS('Term_Pregnancy/Embeddings/triMap_noDup')
TGraph=readRDS('Term_Pregnancy/Layout_Graph_Preg7/trimap')
graph=graph.adjacency(TGraph,mode='undirected',weighted=TRUE)
trimap=CompCorTest(Raw,graph)[,1]
print('trimap')
print(sum(trimap))

#PCA
Tolo=readRDS('Term_Pregnancy/Embeddings/PCA_NoDup')
TGraph=readRDS('Term_Pregnancy/Layout_Graph_Preg7/PCA')
graph=graph.adjacency(TGraph,mode='undirected',weighted=TRUE)
PCA=CompCorTest(Raw,graph)[,1]
print('PCA')
print(sum(PCA))

Quality_Scores=c(sum(tSNE),sum(umap),sum(LV),sum(trimap),sum(PCA),sum(Lamp))
names(Quality_Scores)=c('tSNE','umap','largeVis','trimap','pca','lamp')

