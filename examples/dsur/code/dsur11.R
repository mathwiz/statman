library(car)
library(compute.es)
library(ggplot2)
library(multcomp)
library(effects)
library(WRS2)
library(pastecs)


                                        # ANCOVA

viagraDat<- read.delim(file.path(dataDir, "ViagraCovariate.dat"), header=TRUE)
viagraDat$dose<- factor(viagraDat$dose, levels=c(1:3), labels=c("Placebo", "Low", "High"))
summary(viagraDat)

by(viagraDat$libido, viagraDat$dose, mean)
by(viagraDat$partnerLibido, viagraDat$dose, mean)

leveneTest(viagraDat$libido, viagraDat$dose, center=median)

covariateModel<- aov(partnerLibido ~ dose, data=viagraDat)
summary(covariateModel) # test that covariate does not differ by predictor


contrasts(viagraDat$dose)<- cbind(c(-2,1,1), c(0,-1,1))

predictorFirst<- aov(libido ~ dose + partnerLibido, data=viagraDat)
summary(predictorFirst)
summary.lm(predictorFirst) # contrasts

covariateFirst<- aov(libido ~ partnerLibido + dose, data=viagraDat)
summary(covariateFirst)
summary.lm(covariateFirst) # contrasts

Anova(covariateFirst, type="III")

adjustedMeans<- effect("dose", covariateFirst, se=TRUE)
summary(adjustedMeans)
adjustedMeans$se # standard error


                                        # Interaction model

intModel<- aov(libido ~ partnerLibido + dose + dose:partnerLibido, data=viagraDat)
summary(intModel)
summary.lm(intModel)
Anova(intModel, type="III")


                                        # Post hoc tests in ANCOVA

postHocs<- glht(covariateFirst, linfct=mcp(dose="Tukey"))
summary(postHocs)
confint(postHocs)

plot(covariateFirst)


                                        # Robust ANCOVA

robustModel<- ancova(mischief2 ~ cloak + mischief1, data=invisibility)
robustModel

