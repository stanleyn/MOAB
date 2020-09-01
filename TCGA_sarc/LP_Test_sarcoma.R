source('MOAB_main/Benchmark_HD_LD.R')
source('TCGA_sarc/Process_TCGA_Sarcoma.R')

Raw=t(AllX)
PointLab=nodelab

#########
#tSNE
########

#read in data
tEmbed=readRDS('TCGA_sarc/embeddings/tSNE')
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

tEmbed=readRDS('TCGA_sarc/embeddings/UMAP')
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

tEmbed=readRDS('TCGA_sarc/embeddings/LargeVis')
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

#############################
#PCA
##############################

tEmbed=readRDS('TCGA_sarc/embeddings/PrComp')
kVals=c(10,25,50,75,100,200,300)

#take transpose only for tEmbed
kMat_PCA=matrix(0,nrow=length(kVals),ncol=30)

for(i in 1:length(kVals)){
print('k we are on')
print(i)
Res=Benchmark_HD_LD(tEmbed,Raw,PointLab,kVals[i],0)
kMat_PCA[i,]=Res
}
rownames(kMat_PCA)=kVals

######################
#TriMap########
#####################
print('on trimap')
tEmbed=readRDS('TCGA_sarc/embeddings/TriMap')
kVals=c(10,25,50,75,100,200,300)

#take transpose only for tEmbed
kMat_TriMap=matrix(0,nrow=length(kVals),ncol=30)

for(i in 1:length(kVals)){
print('k we are on')
print(i)
Res=Benchmark_HD_LD(tEmbed,Raw,PointLab,kVals[i],0)
kMat_TriMap[i,]=Res
}
rownames(kMat_TriMap)=kVals

##############################
#Lamp
###############################
print('on lamp')
tEmbed=readRDS('TCGA_sarc/embeddings/Lamp')
kVals=c(10,25,50,75,100,200,300)

#take transpose only for tEmbed
kMat_Lamp=matrix(0,nrow=length(kVals),ncol=30)

for(i in 1:length(kVals)){
print('k we are on')
print(i)
Res=Benchmark_HD_LD(tEmbed,Raw,PointLab,kVals[i],0)
kMat_Lamp[i,]=Res
}
rownames(kMat_Lamp)=kVals

#############################################
#collect results and plotting
library('ggplot2')
library('reshape2')
library('plyr')

stop('')
FullDF=rbind(kMat_tSNE,kMat_UMAP,kMat_LV,kMat_PCA,kMat_TriMap,kMat_Lamp)
#and for making the line plot with only the averages
DT3=ddply(FullDF,.(Method,k),summarize,mean(score))
names(DT3)=c('Method','k','Score')
p<-ggplot(DT3, aes(x=k, y=Score, group=Method)) +
  geom_line(aes(color=Method),lwd=1.3)+
  geom_point(aes(color=Method),size=1.5)+scale_color_manual(values=valVec)
p=p+theme_minimal()+theme(text = element_text(size=22))+xlab('k (# of nearest neighbors)')+ylab('LP Score')+scale_color_manual(values = valVec)+ggtitle('')
p=p+theme_classic()+theme(axis.text.y = element_text(size=22),axis.text.x=element_text(size=22))+theme(legend.position='none')
p=p+theme(axis.title.y = element_text(size=22),axis.title.x=element_text(size=22))
ggsave('~/sarc_LP.pdf',p,width=5,height=5)
