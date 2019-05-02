library(clinfun)
library(ggplot2)
library(pastecs)
library(pgirmess)


                                        # Two independent conditions

drugDat<- read.delim(file.path(dataDir, "Drug.dat"), header=TRUE)
summary(drugDat)

sunModel<- wilcox.test(sundayBDI ~ drug, data=drugDat)
sunModel
wedModel<- wilcox.test(wedsBDI ~ drug, data=drugDat)
wedModel


                                        # Two related conditions (repeated measures)

ecstasyDat<- subset(drugDat, drug=="Ecstasy")
summary(ecstasyDat)

alcoholDat<- subset(drugDat, drug=="Alcohol")
summary(alcoholDat)

alcoholModel<- wilcox.test(alcoholDat$wedsBDI, alcoholDat$sundayBDI, paired=TRUE, correct=FALSE)
alcoholModel

ecstasyModel<- wilcox.test(ecstasyDat$wedsBDI, ecstasyDat$sundayBDI, paired=TRUE, correct=FALSE)
ecstasyModel

