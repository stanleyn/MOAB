GlobalMetric=function(Embed,Raw,PointLab){
library('foreach')
library('doParallel')	
library('FNN')


cl=makeCluster(50)
registerDoParallel(cl)
LVec=c()
custC=function(L1,L2){
Diff=c(L1$Diff,L2$Diff)
Ent=c(L1$Ent,L2$Ent)
return(list(Diff=Diff,Ent=Ent))
}
DiffVec=foreach(i=1:1000,.combine='custC',.packages='FNN') %dopar%{
#source('~/Dropbox/MV_Feat_Sel/MixtureScore.R')
#choose random point
rndPoint=sample(1:nrow(Embed),1)

#compute the distance from this point to everyone else
distValsTemp=knnx.dist(Embed,t(Embed[rndPoint,]),k=nrow(Embed))
forOrder=knnx.index(Embed,t(Embed[rndPoint,]),k=nrow(Embed))
distVals=rep(0,length(distValsTemp))
distVals[forOrder]=distValsTemp


thresh=sample(5:300,1)

#numNeighbots
InInds=forOrder[1:thresh]
#delete the first one which is the point itself
InInds=InInds[-1]


#get sub matrix
SubMat=Raw[InInds,]

#preduct value
PredVal=colMeans(SubMat)
TrueVal=Raw[rndPoint,]

#compute difference
forDiff=as.matrix(abs(TrueVal-PredVal))      #/TrueVal)
Diff=norm(forDiff,'F')
print('diff')
print(Diff)

#normalize by the norm of the original thing
OrigVec=norm(matrix(TrueVal,nrow=1))
Diff=Diff/OrigVec

#for now i am going to make MixScore 
MixScore=thresh
#MixScore=MixtureScore(InInds,PointLab)
#print(MixScore)

return(list(Diff=Diff,Ent=MixScore))
}
stopCluster(cl)
MedHere=DiffVec[[1]]
Inds=which(MedHere>0)
MedHere=MedHere[Inds]

NumChosen=DiffVec[[2]]
NumChosen=NumChosen[Inds]

#MedVec=c(MedVec,median(MedHere))
#print(MedVec)
#DiffVec
	#}
#MedHere
Out=list()
Out[[1]]=MedHere
Out[[2]]=NumChosen
Out
}
