#purpose: this intended to be a general function to identify features that
#behave like SIGLEC6
#Inputs:
	#graph
~	#nodelabs
	#FullMat: feature x sample

#this has been a script for working with the 3 modality pregnancy data

library('igraph')
source('~/Clean_Multiomics/Compact_Functions/CompCorTest.R')

nodelabs=PointLab
FullMat=Raw

#step 1: for each node count the # of its unique neighbor labels
UVec=c()
for(i in 1:vcount(graph)){

#get the ids of the neighbors
Neigh=ego(graph,order=1,nodes=i)[[1]]
AllLabs=nodelabs[Neigh]


#Labi=nodelabs[i]
#nonI=length(which(AllLabs!=Labi))
#UVec=c(UVec,nonI)

#counts the number of unique modalities that are neighbors
#UVec=c(UVec,length(unique(AllLabs)))

#counting the number of immune related features
UVec=c(UVec,length(which(AllLabs==5)))
}

print('done with UVEC')
#stop('')
#stop('')

relInds=which(UVec>2)

#compute the quality score 
Quality=CompCorTest(FullMat,graph)
Quality=Quality[,1]

#select subset of quality scores
subQ=Quality[relInds]
names(subQ)=relInds

#order by quality score
ordering=order(subQ,decreasing=TRUE)

#get correct indices
getFinalInds=names(subQ)[ordering]
getFinalInds=as.numeric(getFinalInds)

relNodeInds=nodelabs[getFinalInds]
ProtInds=which(relNodeInds==4)

#print those
rownames(FullMat)[getFinalInds[ProtInds]]
