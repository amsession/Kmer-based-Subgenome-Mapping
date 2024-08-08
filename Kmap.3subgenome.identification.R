#!/usr/local/bin/R
#require(gplots);
args<- commandArgs(trailingOnly = TRUE);
csa<-as.matrix(read.table(args[1],row=1,header=T));

chr.tbl<-read.table(args[2]);


chr.lengths<-as.matrix(read.table(args[3],row=1,header=F));
csa.norm<-csa;

for(i in colnames(csa.norm))
{
csa.norm[,i]<-csa.norm[,i]/chr.lengths[i,1];
}

for(i in rownames(chr.tbl))
{
my.iter<-csa.norm[,c(as.character(chr.tbl[i,1]),as.character(chr.tbl[i,2]),as.character(chr.tbl[i,3]))];
assign(paste("my.chr.dat.",i,sep=""),rownames(subset(my.iter,((my.iter[,1]/my.iter[,2])>=2) | ((my.iter[,1]/my.iter[,2])<=1/2) | ((my.iter[,1]/my.iter[,3])<=1/2) | ((my.iter[,1]/my.iter[,3])>=2) | ((my.iter[,2]/my.iter[,3])<=1/2) | ((my.iter[,2]/my.iter[,3])>=2)  )));
}
myobjects<-mget(ls(pattern="^my.chr.dat"));
tot.mer<-Reduce(intersect,myobjects);
sub.norm<-csa.norm[tot.mer,];
write.table(csa.norm,file=args[4],row=T,col=T,quote=F,sep="\t");

write.table(tot.mer,file=args[5],row=T,col=T,quote=F,sep="\t");

write.table(sub.norm,file=args[6],row=T,col=T,quote=F,sep="\t");
pdf("Chr.cluster.pdf",useDingbats=F);
plot(hclust(as.dist(1-cor(sub.norm))));
dev.off();
require(gplots);
pdf("Heatmap.pdf",useDingbats=F);
heatmap.2(sub.norm,scale="row",trace="none",Rowv=as.dendrogram(hclust(as.dist(1-cor(t(sub.norm))))),Colv=as.dendrogram(hclust(as.dist(1-cor(sub.norm)))));
dev.off()



