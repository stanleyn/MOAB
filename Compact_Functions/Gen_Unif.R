Gen_Unif=function(Raw,NumPoints){
#this test is for generating random data and seeing how our dimensionality 
#methods do.

#first check if number of rows of raw is larger than num col
NR=nrow(Raw)
NC=ncol(Raw)
if(NC>NR){
Raw=t(Raw)
}

RndMat=matrix(runif(ncol(Raw)*NumPoints,min=min(Raw),max=max(Raw)),nrow=NumPoints,ncol=ncol(Raw))

NewRaw=rbind(Raw,RndMat)





NewRaw


}
