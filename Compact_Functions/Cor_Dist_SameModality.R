Cor_Dist_SameModality=function(OrigData,Embed,FeatLab){
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
#make array of the indices
indPairs=t(combn(relInds,2))
sampPairs=sample(1:nrow(indPairs),min(10000,nrow(indPairs)),replace=FALSE)

for(i in 1:length(sampPairs)){
relRow=indPairs[sampPairs[i],]
ind1=relRow[1]
ind2=relRow[2]
#get dist in high dimensions

#highD=cor(OrigData[ind1,],OrigData[ind2,])

tempHigh=rbind(OrigData[ind1,],OrigData[ind2,])
highD=as.matrix(dist(tempHigh))[1,2]

tempMat=rbind(Embed[ind1,],Embed[ind2,])
lowD=as.matrix(dist(tempMat))[1,2]
Dists=c(Dists,lowD)
Cors=c(Cors,highD)
}

} #u modality
FinalMat=cbind(Cors,Dists)
print(cor(FinalMat[,1],FinalMat[,2]))
FinalMat
}
