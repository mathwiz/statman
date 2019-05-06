library(car)
library(ggplot2)
library(pastecs)
library(MASS)
library(WRS2)
library(reshape)
library(mvoutlier)
library(mvnormtest)

                                        # MANOVA

ocdDat<- read.delim(file.path(dataDir, "OCD.dat"), header=TRUE)
head(ocdDat, n=40)
ocdDat$Grp<- factor(ocdDat$Group, levels=c("CBT", "BT", "No Treatment Control"), labels=c("CBT", "BT", "NT"))
levels(ocdDat$Grp)
stat.desc(ocdDat)

by(ocdDat$Actions, ocdDat$Grp, stat.desc, basic=FALSE)
by(ocdDat$Thoughts, ocdDat$Grp, stat.desc, basic=FALSE)
by(ocdDat[, 2:3], ocdDat$Grp, cov)

## Shapiro test
cbt<- t(ocdDat[1:10, 2:3])
bt<- t(ocdDat[11:20, 2:3])
nt<- t(ocdDat[21:30, 2:3])

mshapiro.test(cbt)
mshapiro.test(bt)
mshapiro.test(nt)
aq.plot(ocdDat[, 2:3])

## Contrasts
CBT_v_NT<- c(1,0,0)
BT_v_NT<- c(0,1,0)
contrasts(ocdDat$Grp)<- cbind(CBT_v_NT, BT_v_NT)


## Model
ocdModel<- manova(cbind(ocdDat$Actions, ocdDat$Thoughts) ~ Grp, data=ocdDat) 
summary(ocdModel, intercept=TRUE, test="Pillai")
summary(ocdModel, intercept=TRUE, test="Wilks")
summary(ocdModel, intercept=TRUE, test="Hotelling")
summary(ocdModel, intercept=TRUE, test="Roy")

Anova(ocdModel, type="III")

summary.aov(ocdModel) # univariate ANOVA

## Contrasts (do only if significant univariate ANOVA)
actionModel<- lm(Actions ~ Grp, data=ocdDat)
thoughtModel<- lm(Thoughts ~ Grp, data=ocdDat)

summary.lm(actionModel)
summary.lm(thoughtModel)


                                        # Robust MANOVA

## Suggestion: transform all variables to normal (z-score) and then use MANOVA


                                        # Discriminant analysis

ocdDFA<- lda(Grp ~ Actions + Thoughts, data=ocdDat)
ocdDFA

predict(ocdDFA)
plot(ocdDFA)




