CrossEntropy=function(P,ClAtt){
	#this function si for computing cross entropy measure
	#the idea is that we compare the partition we got by using the attribute information
	#inputs:
		#P: this is the propagation matrix we are learning through our task
		#Net: This is our NxN adjacency matrix. Note that N will be smaller than the number of nodes
		#ClAtt: This is the test set labels under our clustering

	#first step is to make sure out P is normalized
	# for(i in 1:nrow(P)){
	# P[i,]=P[i,]/sum(P[i,])
	# }
	 P=P+0.000001
	

	##the first step is to create a null probability distribution##
	AttProbDist=matrix(0,nrow=length(ClAtt),ncol=max(ClAtt))
	for(i in 1:length(ClAtt)){
		AttProbDist[i,ClAtt[i]]=1

	}
	


cEnt=0
for(j in 1:length(P)){
cEnt=cEnt+(AttProbDist[j]*log(P[j]))
}
cEnt=cEnt*-1
cEnt


} ##end of the cross en