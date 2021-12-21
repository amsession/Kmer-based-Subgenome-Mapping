#!/usr/local/bin/R
#require(gplots);
args<- commandArgs(trailingOnly = TRUE);
csa<-as.matrix(read.table(args[1],row=1,header=T));

chr.tbl<-read.table(args[2]);


chr.lengths<-as.matrix(read.table(args[3],row=1,header=F));
csa.norm<-csa;

for(i in col(csa.norm))
{
csa.norm[,i]<-csa.norm[,i]/chr.lengths[i,1];
}

for(i in rownames(chr.tbl))
{
my.iter<-csa.norm[,c(as.character(my.dat[i,1]),as.character(my.dat[i,2]))];
assign(paste("my.chr.dat.",i,sep=""),rownames(subset(my.iter,(my.iter[,1]/my.iter[,2])>=10 | (my.iter[,1]/my.iter[,2])<=1/10) | (my.iter[,1]/my.iter[,3)<=1/10) | (my.iter[,1]/my.iter[,3])>=10) | (my.iter[,2]/my.iter[,3)<=1/10) | (my.iter[,2]/my.iter[,3])>=10) | (my.iter[,1]/my.iter[,4)<=1/10) | (my.iter[,1]/my.iter[,4])>=10) | (my.iter[,2]/my.iter[,4)<=1/10) | (my.iter[,2]/my.iter[,4])>=10) | (my.iter[,3]/my.iter[,4)<=1/10) | (my.iter[,3]/my.iter[,4])>=10) ));
}
myobjects<-mget(ls(pattern="^my.chr.dat"));
tot.mer<-Reduce(intersect,myobjects);
sub.norm<-csa.norm[tot.mer,];
pdf("Chr.cluster.pdf",useDingbats=F);
plot(hclust(as.dist(1-cor(sub.norm))));
dev.off();
require(gplots);
pdf("Heatmap.pdf",useDingbats=F);
heatmap.2(sub.norm,scale="row",trace="none");
dev.off()



write.table(csa.norm,file=args[4],row=T,col=T,quote=F,sep="\t");

write.table(tot.mer,file=args[5],row=T,col=T,quote=F,sep="\t");

write.table(sub.norm,file=args[6],row=T,col=T,quote=F,sep="\t");