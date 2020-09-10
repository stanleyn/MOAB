Benchmark_HD_LD=function(Embedding,rawFeat,ModalityLabel,kk,ClNum){
library('foreach')
library('doParallel')
library('igraph')
library('FastKNN')
source('Helper/TestAlignment.R')
source('Helper/LPTask.R')
source('Helper/CrossEntropy.R')

#Purpose: This function is to measure the alignment of the original high-dimensional space and the computed embedding.

#inputs:
	#Embedding: the coordinates of the embedding (feature x embedding dimension). 
	#rawFeat: the feature x sample matrix 
	#modality label: the vector of modality labels that correspond to the rows of rawFeat
	#kk: the number of nearest neighbors to use to create the kNN graph based on the embedding
	#ClNum: the number of clusters to use for the attributes: if 0, then we choose automatically. Otherwise we specify


#output: 
	#entVec: returns a vector of scores reflecting how well the embedding and original high dimensional space are aligned for the given value of kk. These scores can be averaged to get an estimate of the quality of the alignment.

entVec=c()
cl=makeCluster(25)
registerDoParallel(cl)
entVec=foreach(s=1:30,.combine='c',.packages=c('igraph','FastKNN','MASS')) %dopar% { 

source('Helper/TestAlignment.R')
source('Helper/LPTask.R')
source('Helper/CrossEntropy.R')

# ##sampling part
GetFeats=c()
ULab=unique(ModalityLabel)
for(i in 1:length(ULab)){
	RelInds=which(ModalityLabel==ULab[i])
	print(length(RelInds))
	#sample 500
	NumSamp=min(200,length(RelInds))
	sampSome=sample(RelInds,NumSamp,replace=FALSE)
	GetFeats=c(GetFeats,sampSome)

}
print(max(GetFeats))
print(min(GetFeats))
print(dim(Embedding))
print(dim(rawFeat))

#get the subembedding
SubEmbed=Embedding[GetFeats,]
SubDM=rawFeat[GetFeats,]

print(dim(SubEmbed))
print(dim(SubDM))

#############
#run LP thing
#############

print('setting up data for LP')

#form kNN graph between the samples based on these embedding coordinates. 
Dat=SubEmbed

k=kk
dist_mat <- as.matrix(dist(Dat, method = "euclidean", upper = TRUE, diag=TRUE))
nrst <- lapply(1:nrow(dist_mat), function(i) k.nearest.neighbors(i, dist_mat, k = k))
w <- matrix(nrow = dim(dist_mat), ncol=dim(dist_mat)) ## all NA right now
w[is.na(w)] <- 0 ## populate with 0
for(i in 1:length(nrst)) for(j in nrst[[i]]) w[i,j] = 1

#create the network object
Adj2=w
Net=graph.adjacency(Adj2,mode='undirected')

#visualize the network
colVec=c('#FFD600', '#3F51B5','#F57C00')
V(Net)$color=colVec[ModalityLabel[GetFeats]]

if(ClNum==0){
#use louvain to identify communities
CommRes=membership(cluster_louvain(Net))
CommRes=as.factor(CommRes)
NumClus=length(unique(CommRes))
}

else{NumClus=ClNum}

############
#run alignment thing
############

print('running alignment algorithm')
print(dim(SubDM))
#run the alignment algorithm
Pval=TestAlignment(Adj2,SubDM,NumClus,nrow(SubDM)/2,0) ###I have previously used 500
print(Pval)
return(Pval)
} #t end 

stopCluster(cl)
entVec
} #function end


