#!/usr/local/bin/R
#require(matrixStats);
args<- commandArgs(trailingOnly = TRUE);
csa.norm<-as.matrix(read.table(args[1],row=1,header=T));
GC.tukey<-matrix(nrow=length(rownames(csa.norm)),ncol=20);
colnames(GC.tukey)<-c("Group.df","Group.Sumsq","Group.MeanSq","Residual.df","Residual.Sumsq","Residual.MeanSq","Fvalue","Pr","Sub2-Sub1.diff","Sub2-Sub1.p","Sub2-Sub1.95l","Sub2-Sub1.p95u","Sub3-Sub1.diff","Sub3-Sub1.p","Sub3-Sub1.95l","Sub3-Sub1.p95u","Sub3-Sub2.diff","Sub3-Sub2.p","Sub3-Sub2.95l","Sub3-Sub2.p95u");
rownames(GC.tukey)<-rownames(csa.norm);
subgenome1<-as.character(read.table(args[2])$V1);
subgenome2<-as.character(read.table(args[3])$V1);
subgenome3<-as.character(read.table(args[4])$V1);

for(i in rownames(GC.tukey)){

my.iter1.dat<-data.frame(y=character(),Group=character());my.iter1.dat<-rbind(my.iter1.dat,data.frame(y=csa.norm[i,subgenome1],Group="Sub1"));my.iter1.dat<-rbind(my.iter1.dat,data.frame(y=csa.norm[i,subgenome2],Group="Sub2"));my.iter1.dat<-rbind(my.iter1.dat,data.frame(y=csa.norm[i,subgenome3],Group="Sub3"));fit1<-lm(y ~ Group, my.iter1.dat);

my.anova<-anova(fit1)

GC.tukey[i,1]<-my.anova["Group","Df"];GC.tukey[i,2]<-my.anova["Group","Sum Sq"];GC.tukey[i,3]<-my.anova["Group","Mean Sq"];GC.tukey[i,4]<-my.anova["Residuals","Df"];GC.tukey[i,5]<-my.anova["Residuals","Sum Sq"];GC.tukey[i,6]<-my.anova["Residuals","Mean Sq"];GC.tukey[i,7]<-my.anova["Group","F value"];GC.tukey[i,8]<-my.anova["Group","Pr(>F)"];

my.aov<-aov(fit1);
my.Tukey<-TukeyHSD(my.aov);

GC.tukey[i,9]<-my.Tukey$Group["Sub2-Sub1","diff"];GC.tukey[i,10]<-my.Tukey$Group["Sub2-Sub1","p adj"];GC.tukey[i,11]<-my.Tukey$Group["Sub2-Sub1","lwr"];GC.tukey[i,12]<-my.Tukey$Group["Sub2-Sub1","upr"]
GC.tukey[i,13]<-my.Tukey$Group["Sub3-Sub1","diff"];GC.tukey[i,14]<-my.Tukey$Group["Sub3-Sub1","p adj"];GC.tukey[i,15]<-my.Tukey$Group["Sub2-Sub1","lwr"];GC.tukey[i,16]<-my.Tukey$Group["Sub2-Sub1","upr"]
GC.tukey[i,17]<-my.Tukey$Group["Sub3-Sub2","diff"];GC.tukey[i,18]<-my.Tukey$Group["Sub3-Sub2","p adj"];GC.tukey[i,19]<-my.Tukey$Group["Sub2-Sub1","lwr"];GC.tukey[i,20]<-my.Tukey$Group["Sub2-Sub1","upr"]

}

write.table(GC.tukey,file=args[5],row=T,col=T,quote=F,sep="\t");

