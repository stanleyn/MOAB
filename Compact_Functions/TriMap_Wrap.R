TriMap_Wrap=function(DM){
#purpose: runs triMap
#input:
	#DM: just the matrix we want

library('rPython')

python.exec('import numpy as np')
python.exec('import trimap')

#remove the row and column names in DM
colnames(DM)=NULL
rownames(DM)=NULL

#assign that to a variable
python.assign("X",DM)
python.exec('X=np.asarray(X)')
python.exec('embed=trimap.TRIMAP().fit_transform(X)')

#export the output
Embed=python.get('embed.tolist()')
lo=unlist(Embed)
lo=matrix(lo,ncol=2,byrow=TRUE)

lo
}
