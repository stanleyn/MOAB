Trustworthy_General=function(Orig,Embed,PointLab,k){

#a measure of local quality between original data and embedding
#the version was written for 
#inputs:
	#orig: feature x sample
	#embed: sample x 2
	#PointLab: the label for each of the features

#the number to sample from each modality. 
NumSamp=1000

#assemble the matrix of sampled points
UPointLab=unique(PointLab)

SampIndVec=c()

for(u in 1:length(UPointLab)){
modal=UPointLab[u]

#get candidate indices 
CandInd=which(PointLab==modal)
NumSamp=min(300,length(CandInd))

SampInds=sample(CandInd,NumSamp,replace=FALSE)
SampIndVec=c(SampIndVec,SampInds)
}
print('hi')
print(length(SampIndVec))

############################################

#now choose a k
#k=81
Score=0
for(i in 1:length(SampIndVec)){
	#get the classification of that point
	SampClass=PointLab[SampIndVec[i]]
	
	#find indices that are not in this class
	NotInClass=SampIndVec
	
	#get their sub matrices
	SubOrig=Orig[NotInClass,]
	SubEmbed=Embed[NotInClass,]

	#find nearest neighbors in embedding space
	OrderingEmbedding=knnx.index(SubEmbed,t(Embed[SampIndVec[i],]),k=nrow(SubEmbed))

	#find nearest neighbors in the original space 
	OrderingOrig=knnx.index(SubOrig,t(Orig[SampIndVec[i],]),k=nrow(SubOrig))

	#Identify k nearest neighbors in embedding space
	KNNEmbed=OrderingEmbedding[1:k]

	#identify k nearest neighbors in original space
	KNNOrig=OrderingOrig[1:k]

	#figure out the set diff
	NonNeigh=setdiff(KNNEmbed,KNNOrig)

	if(length(NonNeigh)==0){
		Score=Score+0
	}
	else{
	#compute score
	for(n in 1:length(NonNeigh)){
		#figure out the ranking of the non Neigh in orig Space
		RankOrig=which(OrderingOrig==NonNeigh[n])
		newScore=RankOrig-k
		
		Score=Score+newScore
	}
}

}

#normalize score
N=length(SampIndVec)
print(N)
N2=2*N
k3=3*k
normTerm=2/((N*k)*(N2-k3-1))
print('norm term')
print(normTerm)
print('score')
print(Score)
Score=Score*normTerm
final=1-Score
print(final)
final

}
