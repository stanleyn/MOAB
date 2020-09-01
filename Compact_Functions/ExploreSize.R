#purpose: this function will sample equal number from each modality
#the idea is that if size matters, sampling equal number should cause more mixing between modality

ExploreSize=function(Raw,NodeLabs){
ULab=unique(NodeLabs)
sampInds=c()
for(u in ULab){
relInds=which(NodeLabs==u)
sampVals=sample(relInds,1000,replace=FALSE)
sampInds=c(sampInds,sampVals)
}

RawTwo=Raw[sampInds,]

RawTwo
}
