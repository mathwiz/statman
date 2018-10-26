library(ggplot2)
library(Hmisc)
library(reshape2)

chickFlick <- read.delim("ChickFlick.dat", header=TRUE)
head(chickFlick)

bar <- ggplot(chickFlick, aes(film, arousal))

bar + stat_summary(fun.y=mean, geom="bar", fill="White", colour="Black") + stat_summary(fun.data=mean_cl_normal, geom="pointrange") + labs(x="Film", y="Mean Arousal")
