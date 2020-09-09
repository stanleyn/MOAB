#Description: This code is for implementing the correlation test looking at the correlation structure of neighboring points in the 2D layout computed according to some dimensionality reduction method. We are assessing if neighborhood points in the reduced layout were indeed correlated in high dimensions.

#inputs:
	#FullMat: The feature x sample data matrix
	#LayGraph: a kNN graph of the layout (in igraph format).

#output:
	#A vector of scores for the internal correlation in each community from the layout kNN graph. The sum of this vector can be computed to get an idea of the quality score of the entire representation. 

library('igraph')
library('foreach')
source('Helper/Louvain_Homebrew_Improved.R')
#inputs:
	#FullMat: the full matrix of features
	#LayGraph: a network representation of the layout

CompCorTest=function(FullMat,LayGraph){

cl=makeCluster(5)
registerDoParallel(cl)

#this has the option to repeat many times if you want
OutCor=foreach(s=1:1,.combine='cbind',.packages=c('igraph')) %do% {
print(s)
source('~/Louvain_Homebrew_Improved.R')

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
as.matrix(OutCor)
}
