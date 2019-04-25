library(car)
library(compute.es)
library(ggplot2)
library(multcomp)
library(effects)
library(WRS2)
library(pastecs)


                                        # Factorial ANCOVA

regressionDat<- read.delim(file.path(dataDir, "GogglesRegression.dat"), header=TRUE)
head(regressionDat)
regMod<- lm(attractiveness ~ gender + alcohol + interaction, data=regressionDat)
summary.lm(regMod)



