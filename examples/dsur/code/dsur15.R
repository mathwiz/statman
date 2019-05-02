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



                                        # Multiple independent conditions

soyaDat<- read.delim(file.path(dataDir, "Soya.dat"), header=TRUE)
summary(soyaDat)
tail(soyaDat, n=30)
soyaDat$SoyaLev<- factor(soyaDat$Soya, labels=c("No soya meals per week", "1 soya meal per week", "4 soya meals per week", "7 soya meals per week"))
levels(soyaDat$SoyaLev)

by(soyaDat$Sperm, soyaDat$SoyaLev, stat.desc, basic=FALSE)

leveneTest(soyaDat$Sperm, soyaDat$SoyaLev, center=median)

soyaModel<- kruskal.test(Sperm ~ SoyaLev, data=soyaDat)
soyaModel

by(soyaDat$Ranks, soyaDat$SoyaLev, mean)

kruskalmc(Sperm ~ SoyaLev, data=soyaDat)

kruskalmc(Sperm ~ SoyaLev, data=soyaDat, cont="two-tailed")

jonckheere.test(soyaDat$Sperm, soyaDat$Soya)


                                        # Multiple related conditions (repeated measures)

dietDat<- read.delim(file.path(dataDir, "Diet.dat"), header=TRUE)
stat.desc(dietDat)

dietCompleteCases<- na.omit(dietDat) # in this case not necessary as no NA exist
stat.desc(dietCompleteCases)

friedman.test(as.matrix(dietCompleteCases))
friedmanmc(as.matrix(dietCompleteCases))


