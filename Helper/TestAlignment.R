TestAlignment=function(AdjMat,Attributes,K,S,Plot){

  library('MASS')
	#Inputs:
		#AdjMat is your NxN matrix, potentially sparse
		#Attributes is your NxP matrix of attributes
		#K is the number of communities you expect
		#S is the sample size to use. 
		#Plot: binary indicator for whether to plot empirical entropy distroibutions. 1 if yes, 0 if no

#Step one: get labels from the nodes according to kmeans
  
  print(K)
  print('max Attributes')
  print(min(Attributes))
  print('yes')
  #print(Attributes[1:10,1:10])
  if(rowSums(Attributes)[1]==rowSums(Attributes)[2]){
     K=1
     print('that case!')
   }
  else{K=K}
  ClAtt=kmeans(Attributes,centers=K)$cluster

print('done with ClAtt')
  #vectors for recording the entropies 
  EntropyLP=c()
  EntropyPerm=c()

  #do permutation test 1000 times
  for(s in 1:1){
  	print(s)
  Lab50=sample(1:nrow(Attributes),S,replace=FALSE)
  #do the true label propagation task
  
  Assn=LPTask(AdjMat,Lab50,ClAtt[Lab50],K,ClAtt[-Lab50])

  EntropyLP=c(EntropyLP,Assn)
  #do the permutation label propagation task
  AssnPerm=LPTask(AdjMat,Lab50,sample(ClAtt[Lab50],S,replace=FALSE),K,ClAtt[-Lab50])
  print(EntropyLP)
  EntropyPerm=c(EntropyPerm,AssnPerm)
  print(EntropyPerm)
  }
 
#Compute pvalue in terms of overlap
 
#remove NAs that may be messing things up
permNAInds=which(is.na(EntropyPerm))
if(length(permNAInds>0)){
 EntropyPerm=EntropyPerm[-permNAInds] 
}

LPNAInds=which(is.na(EntropyLP))
if(length(LPNAInds)>0){
EntropyLP=EntropyLP[-LPNAInds]
}

print('here')
 PermMin=min(EntropyPerm)
 PermMax=max(EntropyPerm)
 
LPMax=max(EntropyLP)
 LPMin=min(EntropyLP)

# ###cases####
##if LPmax<PermMin
 if(LPMax<PermMin){
 PVal=0
 }

 #this is the case that LPMax>PermMin
 else{
	print(EntropyPerm)
	Bound=LPMax
# #what proportion of Entropy Perm are less than bound
 Prop=length(which(EntropyPerm<Bound))
 Prop=Prop/length(EntropyPerm)
 PVal=Prop
 
 }

#plot the empirical distributions of entropies
globalMin=min(PermMin,LPMin)
globalMax=max(PermMax,LPMax)
print(globalMin)
print(globalMax)

#med ent
medEnt=(median(EntropyPerm,na.rm=TRUE)-median(EntropyLP))/(max(median(EntropyLP,na.rm=TRUE),median(EntropyPerm,na.rm=TRUE)))

####return median entropy
medEnt
} ##function end
