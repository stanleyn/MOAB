#Process_TCGA_Sarcoma.R
#data: June 1, 2020
#purpose: puts miRNA, RNAseq, RPPA gene, and RPPA analyte into a format so that the samples match
#data comes from : http://linkedomics.org/data_download/TCGA-SARC/

#RPPA_analyte
RPPA_analyte=read.csv('TCGA_sarc/data/Human__TCGA_SARC__MDA__RPPA__MDA_RPPA__01_28_2016__BI__Analyte__Firehose_RPPA.csv',header=TRUE,stringsAsFactors=FALSE)
rownames(RPPA_analyte)=RPPA_analyte[,1]
RPPA_analyte=RPPA_analyte[,-1]

#RPPA_gene
RPPA_gene=read.csv('TCGA_sarc/data/Human__TCGA_SARC__MDA__RPPA__MDA_RPPA__01_28_2016__BI__Gene__Firehose_RPPA.csv',header=TRUE,stringsAsFactors=FALSE)
rownames(RPPA_gene)=RPPA_gene[,1]
RPPA_gene=RPPA_gene[,-1]

#RNA seq
RNASeq=read.csv('TCGA_sarc/data/Human__TCGA_SARC__UNC__RNAseq__HiSeq_RNA__01_28_2016__BI__Gene__Firehose_RSEM_log2.csv',header=TRUE,stringsAsFactors=FALSE)
rownames(RNASeq)=RNASeq[,1]
RNASeq=RNASeq[,-1]

#miRNA
miRNA=read.csv('TCGA_sarc/data/Human__TCGA_SARC__BDGSC__miRNASeq__HS_miR__01_28_2016__BI__Gene__Firehose_RPM_log2.csv',header=TRUE,stringsAsFactors=FALSE)
rownames(miRNA)=miRNA[,1]
miRNA=miRNA[,-1]

#match indices to RPPA analyte
RNASeqMatch=c()

for(i in 1:ncol(RPPA_analyte)){
	Ind=which(colnames(RNASeq)==colnames(RPPA_analyte)[i])
	if(length(Ind)==0){
		RNASeqMatch=c(RNASeqMatch,NA)
	}
	else{RNASeqMatch=c(RNASeqMatch,Ind)}
}

miRNAMatch=c()
for(i in 1:ncol(RPPA_analyte)){
	Ind=which(colnames(miRNA)==colnames(RPPA_analyte)[i])
	if(length(Ind)==0){
		miRNAMatch=c(miRNAMatch,NA)
	}
	else{miRNAMatch=c(miRNAMatch,Ind)}
}

#remove NA stuff
naRNA=which(is.na(RNASeqMatch))
naMir=which(is.na(miRNAMatch))

#patients to remove
toRemove=c(naRNA,naMir)

#list where each entry is dataset
tData=list()
tData[[1]]=scale(t(RPPA_analyte[,-toRemove]))
tData[[2]]=scale(t(RPPA_gene[,-toRemove]))
tData[[3]]=scale(t(RNASeq[,RNASeqMatch[-toRemove]]))
tData[[4]]=scale(t(miRNA[,miRNAMatch[-toRemove]]))

names(tData)=c('RPPA_analyte','RPPA_gene','RNASeq','miRNA')

#everything concatenated
AllX=cbind(tData[[1]],tData[[2]],tData[[3]],tData[[4]])
nodelab=rep(c(1:4),c(ncol(tData[[1]]),ncol(tData[[2]]),ncol(tData[[3]]),ncol(tData[[4]])))

