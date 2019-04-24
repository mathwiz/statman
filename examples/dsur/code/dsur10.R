library(WRS2)
library(car)
library(ggplot2)
library(pastecs)
library(compute.es)

                                        # ANOVA as regression

viagraDummy<- read.delim(file.path(dataDir, "dummy.dat"), header=TRUE)
summary(viagraDummy)

viagraReg<- lm(libido ~ dummy1 + dummy2, data=viagraDummy, na.action=na.exclude)
summary(viagraReg)

                                        # ANOVA as regression with contrasts

viagraContrast<- read.delim(file.path(dataDir, "Contrast.dat"), header=TRUE)
summary(viagraContrast)

contrastReg<- lm(libido ~ dummy1 + dummy2, data=viagraContrast, na.action=na.exclude)
summary(contrastReg)

                                        # ANOVA
viagraDat<- read.delim(file.path(dataDir, "Viagra.dat"), header=TRUE)
viagraDat$dose<- factor(viagraDat$dose, labels=c("Placebo", "Low", "High"))
summary(viagraDat)

by(viagraDat$libido, viagraDat$dose, stat.desc)

leveneTest(viagraDat$libido, viagraDat$dose, center=median)

viagraModel<- aov(libido ~ dose, data=viagraDat)
summary(viagraModel)
plot(viagraModel)

oneway.test(libido ~ dose, data=viagraDat)


                                        # Robust ANOVA

viagraWide<- unstack(viagraDat, libido ~ dose)
names(viagraWide)<- c("Placebo", "Low", "High")
head(viagraWide) # turns out this is not needed

t1way(libido ~ dose, data=viagraDat, tr=.1)
med1way(libido ~ dose, data=viagraDat)
t1waybt(libido ~ dose, data=viagraDat, tr=.1, nboot=2000)


                                        # Planned Contrasts

summary.lm(viagraModel) # dummy variable with Placebo as baseline

contrasts(viagraDat$dose)<- contr.helmert(3) # helmert contrasts
viagraDat$dose
viagraModel.helm<- aov(libido ~ dose, data=viagraDat)
summary.lm(viagraModel.helm)

contrast1<- c(-2,1,1) # custom contrast
contrast2<- c(0,-1,1) # custom contrast

contrasts(viagraDat$dose)<- cbind(contrast1, contrast2)
viagraDat$dose
viagraModel.custom<- aov(libido ~ dose, data=viagraDat)
summary.lm(viagraModel.custom)


                                        # Trend Analysis

contrasts(viagraDat$dose)<- contr.poly(3)
viagraDat$dose
viagraModel.trend<- aov(libido ~ dose, data=viagraDat)
summary.lm(viagraModel.trend)


                                        # Post hoc comparisons

pairwise.t.test(viagraDat$libido, viagraDat$dose, paired=FALSE, p.adjust.method="bonferroni")
pairwise.t.test(viagraDat$libido, viagraDat$dose, paired=FALSE, p.adjust.method="BH")

lincon(libido ~ dose, data=viagraDat, tr=.2)
mcppb20(libido ~ dose, data=viagraDat, nboot=2000)


