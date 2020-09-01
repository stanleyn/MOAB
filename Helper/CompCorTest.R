#Description: This code is for implementing the correlation test looking at how well the 2D layout is doing

library('igraph')
library('foreach')
source('~/Louvain_Homebrew_Improved.R')
#inputs:
	#FullMat: the full matrix of features
	#LayGraph: a network representation of the layout

CompCorTest=function(FullMat,LayGraph){

cl=makeCluster(35)
registerDoParallel(cl)

OutCor=foreach(s=1:2,.combine='cbind',.packages=c('igraph')) %do% {
print(s)
source('~/Louvain_Homebrew_Improved.R')

#step 1: partition the layout graph into modules
#findComm=cluster_louvain(LayGraph,weights=E(LayGraph)$weight)
#findComm=membership(findComm)

findComm=Louvain_Homebrew_Improved(LayGraph,1,1)

CorScoreVec=rep(0,vcount(LayGraph))

#go through each community, find average coordinates and compute correl
for(i in 1:max(findComm)){
relInds=which(findComm==i)
SubFeat=FullMat[relInds,]
MeanFeat=colMeans(SubFeat)


for(j in 1:length(relInds)){
getInd=relInds[j]
RawVal=FullMat[getInd,]
CorScoreVec[getInd]=cor(MeanFeat,RawVal)
}
print(i)

} #i
return(CorScoreVec)
}
stopCluster(cl)
OutCor
}
