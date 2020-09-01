LPTask=function(A,LabInds,Labs,K,ULabs){
	#inputs:
		#A: The NxN adjacency matrix
		#LabInds: The indices of the labeled nodes
		#Labs: The lables of the labeled node
		#K: the number of classes
		#ULabs: the labels of the unlabeled nodes

	#create the transition matrix
	T=matrix(0,nrow=nrow(A),ncol=ncol(A))
	A=A+0.00001
	for(i in 1:nrow(T)){
		for(j in 1:nrow(T))
		if(i<j){
		val=A[i,j]/sum(A[,j])
		T[i,j]=val
		T[j,i]=val
		}
	}
	LowInds=which(T<0.1)

	#create Laplacian
	Degs=rowSums(T)
	
	
	##otherwise use normalized adj
	
	for(j in 1:nrow(T)){
		T[j,]=T[j,]/Degs[j]
	}


##begin phase of separating A into labeled and unlabeled parts
NumLab=length(Labs)
UnLabInd1=NumLab+1

#get indices for unlabeled nodes
ULabInds=setdiff(1:nrow(A),LabInds)

#now creating 4 submatrices
LL=T[LabInds,LabInds]
LU=T[LabInds,ULabInds]
UL=T[ULabInds,LabInds]
UU=T[ULabInds,ULabInds]

#create the Y^L matrix
YL=matrix(0,nrow=NumLab,ncol=K)
	for(i in 1:length(LabInds)){
		RelInd=LabInds[i]
		YL[i,Labs[i]]=1
	}

IMat=matrix(0,nrow=nrow(UU),ncol=ncol(UU))
diag(IMat)=1

YU=ginv(IMat-UU)%*%UL%*%YL
print('done computing inverse')
#compute cross entropy
Cent=CrossEntropy(YU,ULabs)
Cent
}
