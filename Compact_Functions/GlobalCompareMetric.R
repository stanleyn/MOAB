GlobalCompareMetric=function(Embed,Orig,numClus){
library('FNN')

cl=makeCluster(25)
registerDoParallel(cl)

RepRes=foreach(s=1:100,.combine='c',.packages=c('FNN')) %dopar% {

#cluster the embedding
Clus=kmeans(Embed,centers=numClus)
CenterVals=Clus$centers
kClus=Clus$cluster

#for each cluster, find its closest neighbors
UClus=unique(kClus)

forCompare=c()

for(i in UClus){
	relInds=which(kClus==i)
	SubEmbed=Embed[relInds,]
	relCenter=CenterVals[i,]

	print(dim(SubEmbed))
	print(dim(relCenter))

	#find indices of nearest neighbors
	NumToGet=min(50,nrow(SubEmbed))
	OrderFromCenter=knnx.index(SubEmbed,t(relCenter),k=NumToGet)
	print(OrderFromCenter)

	#map to original Ind
	OrigInd=relInds[OrderFromCenter]
	forCompare=c(forCompare,OrigInd)

}

#calculate distances in embedding space
SEComp=Embed[forCompare,]
SOComp=Orig[forCompare,]
DistEmbed=as.matrix(dist(SEComp))
DistO=as.matrix(dist(SOComp))

DistEmbed=DistEmbed[lower.tri(DistEmbed)]
DistO=DistO[lower.tri(DistO)]

#compute cosine similarity
sim=cor(DistEmbed,DistO)
return(sim)

}
stopCluster(cl)
RepRes

}
