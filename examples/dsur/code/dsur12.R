library(car)
library(compute.es)
library(ggplot2)
library(multcomp)
library(effects)
library(WRS2)
library(pastecs)
library(reshape)


                                        # Factorial ANOVA as regression

regressionDat<- read.delim(file.path(dataDir, "GogglesRegression.dat"), header=TRUE)
head(regressionDat)
regMod<- lm(attractiveness ~ gender + alcohol + interaction, data=regressionDat)
summary.lm(regMod)


                                        # Factorial ANOVA

gogglesDat<- read.csv(file.path(dataDir, "goggles.csv"), header=TRUE)
head(gogglesDat)
gogglesDat$alcohol<- factor(gogglesDat$alcohol, levels=c("None", "2 Pints", "4 Pints"))
summary(gogglesDat)

by(gogglesDat$attractiveness, list(gogglesDat$alcohol, gogglesDat$gender), stat.desc)

leveneTest(gogglesDat$attractiveness, interaction(gogglesDat$alcohol, gogglesDat$gender), center=median)

contrasts(gogglesDat$alcohol)<- cbind(c(-2,1,1), c(0,-1,1))
gogglesDat$alcohol
contrasts(gogglesDat$gender)<- c(-1,1)
gogglesDat$gender

gogglesModel<- aov(attractiveness ~ gender + alcohol + gender:alcohol, data=gogglesDat)
summary.lm(gogglesModel)
Anova(gogglesModel, type="III")


                                        # Robust factorial ANOVA

robustModel<- t2way(attractiveness ~ gender + alcohol + gender:alcohol, data=gogglesDat)
robustModel


medianModel<- med2way(attractiveness ~ gender + alcohol + gender:alcohol, data=gogglesDat)
medianModel

