library('ggplot2')
library('readr')
library('tidyr')
### Ecoli大肠杆菌
E=read.csv('luoill_NEB1_Ecoli.csv',header = T)
E1=E[c(2,3,5)]
colnames(E1)=c("Local","illumina","NEB")
#ggplot(x)+geom_line(aes(x = Local,y=illumina,group=1),color="chartreuse3")+
#geom_line(aes(x=Local,y=NEB,group=1),color="red")+labs(title="2016年广电网络广州用户流失分析")

E0 <- gather(E1,key = Type,value = coverage,illumina,NEB)
E0[,2] <- as.factor(E0[,2])

figure=ggplot(E0,aes(x=Local,y=coverage,color=Type,group=Type))+geom_line()
ggsave('luoill_NEB1_Ecoli.png', figure, width = 10, height = 5.5)

### strep肺炎链球菌
S=read.csv('luoill_NEB10_strep.csv',header = T)
S1=S[c(2,3,5)]
colnames(S1)=c("Local","illumina","NEB")
#ggplot(x)+geom_line(aes(x = Local,y=illumina,group=1),color="chartreuse3")+
  #geom_line(aes(x=Local,y=NEB,group=1),color="red")+labs(title="2016年广电网络广州用户流失分析")

S0 <- gather(S1,key = Type,value = coverage,illumina,NEB)
S0[,2] <- as.factor(S0[,2])

figure=ggplot(S0,aes(x=Local,y=coverage,color=Type,group=Type))+geom_line()
ggsave('luoill_NEB10_strep.png', figure, width = 10, height = 5.5)
