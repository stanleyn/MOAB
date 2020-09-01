Cor_Dist_Mix=function(OrigData,Embed,FeatLab){
#Purpose: We will select 1000 pairs of points from each modality and compute
#correlation in original space and correlation in embedding


if(nrow(OrigData)<ncol(OrigData)){
OrigData=t(OrigData)
}

UModality=unique(FeatLab)

Dists=c()
Cors=c()
for(u in UModality){
relInds=which(FeatLab==u)

#sample those relInds
sampRel=sample(relInds,min(2000,length(relInds)),replace=FALSE)

for(j in sampRel){
candSample=c(1:nrow(OrigData))[-j]
#sample partnet
partner=sample(candSample,1,replace=FALSE)

tempHigh=rbind(OrigData[j,],OrigData[partner,])
highD=as.matrix(dist(tempHigh))[1,2]

tempMat=rbind(Embed[j,],Embed[partner,])
lowD=as.matrix(dist(tempMat))[1,2]
Dists=c(Dists,lowD)
Cors=c(Cors,highD)
}

} #u modality
FinalMat=cbind(Cors,Dists)
print(cor(FinalMat[,1],FinalMat[,2]))
FinalMat
}
