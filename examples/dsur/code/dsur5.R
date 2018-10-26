projectDir <- "~/Dev/Github/statman/examples/dsur"
setwd(file.path(projectDir, "code"))
getwd()
load(".RData")
ls()
dataDir <- file.path(projectDir, "data")


library(ggplot2)
library(Hmisc)
library(reshape2)
library(car)
library(pastecs)
library(psych)


chickFlick <- read.delim("ChickFlick.dat", header=TRUE)
head(chickFlick)

bar <- ggplot(chickFlick, aes(film, arousal))

bar + stat_summary(fun.y=mean, geom="bar", fill="White", colour="Black") + stat_summary(fun.data=mean_cl_normal, geom="pointrange") + labs(x="Film", y="Mean Arousal")
