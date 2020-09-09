#purpose: implement the test to identtify the important bridge nodes on the 3 modality dataset

library('igraph')
library('largeVis')
library('doParallel')
library('foreach')

#load dataset
Raw=readRDS('TCGA_adeno/data/AllX')
PointLab=readRDS('TCGA_adeno/data/nodelabs')
source('MOAB_main/CompCorTest.R')

#tSNE
Tolo=readRDS('TCGA_adeno/Embeddings/tSNE')
TGraph=readRDS('TCGA_adeno/Layout_Graphs/tSNE')
graph=graph.adjacency(TGraph,mode='undirected',weighted=TRUE)
tSNE=CompCorTest(Raw,graph)[,1]
print('tSNE')
print(sum(tSNE))

#umap
Tolo=readRDS('TCGA_adeno/Embeddings/UMAP')
TGraph=readRDS('TCGA_adeno/Layout_Graphs/umap')
graph=graph.adjacency(TGraph,mode='undirected',weighted=TRUE)
umap=CompCorTest(Raw,graph)[,1]
print('umap')
print(sum(umap))

#largeVis
Tolo=readRDS('TCGA_adeno/Embeddings/LargeVis')
TGraph=readRDS('TCGA_adeno/Layout_Graphs/LV')
graph=graph.adjacency(TGraph,mode='undirected',weighted=TRUE)
LV=CompCorTest(Raw,graph)[,1]
print('LargeVis')
print(sum(LV))

#TriMap
Tolo=readRDS('TCGA_adeno/Embeddings/TriMap')
TGraph=readRDS('TCGA_adeno/Layout_Graphs/trimap')
graph=graph.adjacency(TGraph,mode='undirected',weighted=TRUE)
trimap=CompCorTest(Raw,graph)[,1]
print('trimap')
print(sum(trimap))

#PCA
Tolo=readRDS('TCGA_adeno/Embeddings/PrComp')
TGraph=readRDS('TCGA_adeno/Layout_Graphs/PCA')
graph=graph.adjacency(TGraph,mode='undirected',weighted=TRUE)
PCA=CompCorTest(Raw,graph)[,1]
print('PCA')
print(sum(PCA))

#LAMP
Tolo=readRDS('TCGA_adeno/Embeddings/Lamp')
TGraph=readRDS('TCGA_adeno/Layout_Graphs/Lamp')
graph=graph.adjacency(TGraph,mode='undirected',weighted=TRUE)
Lamp=CompCorTest(Raw,graph)[,1]
print('lamp')
print(sum(Lamp))

Quality_Scores=c(sum(tSNE),sum(umap),sum(LV),sum(trimap),sum(PCA),sum(Lamp))
names(Quality_Scores)=c('tSNE','umap','largeVis','trimap','pca','lamp')

