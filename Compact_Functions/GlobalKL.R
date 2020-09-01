GlobalKL=function(Orig,EmbedList,PointLab){
library('doParallel')
library('foreach')

#cl=makeCluster(5)
#registerDoParallel(cl)

#RepRes=foreach(s=1:100,.combine='c') %dopar% {

#step 1 is to sample 1000 points from each modality 
UPointLab=unique(PointLab)
toGet=c()

for(u in UPointLab){

#sample indices to use
rel=which(PointLab==u)
NumSamp=min(length(rel),1000)
getInds=sample(rel,NumSamp,replace=FALSE)
toGet=c(toGet,getInds)
}
print(max(toGet))

KLMat=matrix(0,nrow=length(EmbedList),ncol=length(toGet))

#get the embedding out
for(e in 1:length(EmbedList)){

Embed=EmbedList[[e]]

#get sub embedding
SubEmbed=Embed[toGet,]
SubOrig=Orig[toGet,]

DistEmbed=as.matrix(dist(SubEmbed))
DistOrig=as.matrix(dist(SubOrig))

KLVec=c()

for(i in 1:nrow(SubEmbed)){

E=DistEmbed[i,]/max(DistEmbed[i,])
EmbedCDF=ecdf(E)(E)

#EmbedCDF=E

O=DistOrig[i,]/max(DistOrig[i,])
OrigCDF=ecdf(O)(O)

#OrigCDF=O
#now KL divergence

Rat=log(OrigCDF/EmbedCDF)
#nan inds
#nanInds=which(is.nan(Rat))
#print(max(Rat))
#Rat=Rat[-nanInds]*OrigCDF[-nanInds]

Rat=Rat*OrigCDF
KL=sum(Rat)

#KL=cor(O,E)


KLVec=c(KLVec,KL)
} #for i in 1:nrow(SubEmbed)
	KLMat[e,]=KLVec
	} #for e in embed list

KLMat

}
