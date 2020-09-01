LocalMetric_Predict=function(EmbedList,Raw,PointLab){
library('foreach')
library('doParallel')	
library('FNN')

#inputs:
	#EmbedList: the list of the embddings
	#Raw is the original data
	#PointLab is the label for each feature

cl=makeCluster(50)
registerDoParallel(cl)
LVec=c()
custC=function(L1,L2){
Diff=cbind(L1$Diff,L2$Diff)
return(Diff)
}
DiffVec=foreach(i=1:1000,.combine='cbind',.packages='FNN') %dopar%{

#sample a common set of points
rndPoint=sample(1:nrow(EmbedList[[1]]),1)
thresh=sample(5:300,1)

#set the diff
Diff=c()

for(i in 1:length(EmbedList)){

Embed=EmbedList[[i]]

#compute the distance from this point to everyone else
distValsTemp=knnx.dist(Embed,t(Embed[rndPoint,]),k=nrow(Embed))
forOrder=knnx.index(Embed,t(Embed[rndPoint,]),k=nrow(Embed))
distVals=rep(0,length(distValsTemp))
distVals[forOrder]=distValsTemp


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
DiffTemp=norm(forDiff,'F')
print('diff')
print(Diff)

#normalize by the norm of the original thing
OrigVec=norm(matrix(TrueVal,nrow=1))
DiffTemp=DiffTemp/OrigVec
Diff=c(Diff,DiffTemp)

	}
return(Diff)
}
stopCluster(cl)
Out=DiffVec
Out
}
