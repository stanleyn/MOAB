source('MOAB_main/Benchmark_HD_LD.R')
Raw=readRDS('Term_Pregnancy/data/AllX_NoDup')
PointLab=readRDS('Term_Pregnancy/data/nodelabs_NoDup')

#########
#tSNE
########

#read in data
tEmbed=readRDS('Term_Pregnancy/Embeddings/tSNE_noDup')

kVals=c(10,25,50,75,100,200,300)
kMat_tSNE=matrix(0,nrow=length(kVals),ncol=30)

for(i in 1:length(kVals)){
print('k we are on')
print(i)
Res=Benchmark_HD_LD(tEmbed,Raw,PointLab,kVals[i],0)
print(mean(Res))
kMat_tSNE[i,]=Res
}
rownames(kMat_tSNE)=kVals

#######################
#UMAP
#######################

tEmbed=readRDS('Term_Pregnancy/Embeddings/UMAP_noDup')
kVals=c(10,25,50,75,100,200,300)

kMat_UMAP=matrix(0,nrow=length(kVals),ncol=30)

for(i in 1:length(kVals)){
print('k we are on')
print(i)
Res=Benchmark_HD_LD(tEmbed,Raw,PointLab,kVals[i],0)
print(mean(Res))
kMat_UMAP[i,]=Res
}
rownames(kMat_UMAP)=kVals

####################
#Large Vis###########
####################

tEmbed=readRDS('Term_Pregnancy/Embeddings/LargeVis_noDup')
kVals=c(10,25,50,75,100,200,300)

#take transpose only for tEmbed
tEmbed=t(tEmbed)

kMat_LV=matrix(0,nrow=length(kVals),ncol=30)

for(i in 1:length(kVals)){
print('k we are on')
print(i)
Res=Benchmark_HD_LD(tEmbed,Raw,PointLab,kVals[i],0)
print(mean(Res))
kMat_LV[i,]=Res
}
rownames(kMat_LV)=kVals
#######################################################################

############
##TriMap####
###########

tEmbed=readRDS('Term_Pregnancy/Embeddings/triMap_noDup')
kVals=c(10,25,50,75,100,200,300)

kMat_TriMap=matrix(0,nrow=length(kVals),ncol=30)

for(i in 1:length(kVals)){
print('k we are on')
print(i)
Res=Benchmark_HD_LD(tEmbed,Raw,PointLab,kVals[i],0)
print(mean(Res))
kMat_TriMap[i,]=Res
}
rownames(kMat_TriMap)=kVals


###################
#Lamp
tEmbed=readRDS('Term_Pregnancy/Embeddings/Lamp')
kVals=c(10,25,50,75,100,200,300)

kMat_Lamp=matrix(0,nrow=length(kVals),ncol=30)

for(i in 1:length(kVals)){
print('k we are on')
#print(i)
Res=Benchmark_HD_LD(tEmbed,Raw,PointLab,kVals[i],0)
print(mean(Res))
kMat_Lamp[i,]=Res
}
rownames(kMat_Lamp)=kVals

##########
##PCA

tEmbed=readRDS('Term_Pregnancy/Embeddings/PCA_NoDup')
kVals=c(10,25,50,75,100,200,300)

kMat_PrComp=matrix(0,nrow=length(kVals),ncol=30)

for(i in 1:length(kVals)){
print('k we are on')
print(i)
Res=Benchmark_HD_LD(tEmbed,Raw,PointLab,kVals[i],0)
print(mean(Res))
kMat_PrComp[i,]=Res
}
rownames(kMat_PrComp)=kVals

library('ggplot2')
library('reshape2')
library('plyr')

FullDF=rbind(rowMeans(kMat_tSNE),rowMeans(kMat_UMAP),rowMeans(kMat_LV),rowMeans(kMat_TriMap),rowMeans(kMat_PrComp),rowMeans(kMat_Lamp))
rownames(FullDF)=c('tSNE','UMAP','LargeVis','TriMap','PCA','Lamp')

#optional plotting

#valVec=c('gray50','darkviolet','darkolivegreen3','deeppink1','deepskyblue4','darkorange2','darkgoldenrod','black','darkblue')
#valVec=valVec[-c(5,7,9)]
#FullDF=melt(FullDF)
#names(FullDF)=c('Method','k','score')
#p<-ggplot(DT3, aes(x=k, y=Score, group=Method)) +
#  geom_line(aes(color=Method),lwd=1.3)+
#  geom_point(aes(color=Method),size=1.5)+scale_color_manual(values=valVec)
#p=p+theme_minimal()+theme(text = element_text(size=22))+xlab('k (# of nearest neighbors)')+ylab('LP Score')+scale_color_manual(values = valVec)+ggtitle('')
#p=p+theme_classic()+theme(axis.text.y = element_text(size=22),axis.text.x=element_text(size=22))+theme(legend.position='none')
#p=p+theme(axis.title.y = element_text(size=22),axis.title.x=element_text(size=22))
#ggsave('~/termPreg_LP.pdf',p,width=5,height=5)

