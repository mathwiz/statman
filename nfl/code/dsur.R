library(ggplot2)
library(Hmisc)

chickFlick <- read.delim("ChickFlick.dat", header=TRUE)

bar <- ggplot(chickFlick, aes(film, arousal))

bar + stat_summary(fun.y=mean, geom="bar", fill="White", colour="Black") + stat_summary(fun.data=mean_cl_normal, geom="pointrange") + labs(x="Film", y="Mean Arousal")

bar <- ggplot(chickFlick, aes(film, arousal, fill=gender))
bar + stat_summary(fun.y=mean, geom="bar", position="dodge") + stat_summary(fun.data=mean_cl_normal, geom="errorbar", position=position_dodge(width=0.90), width=0.2)

bar <- ggplot(chickFlick, aes(film, arousal, fill=film))
bar + stat_summary(fun.y=mean, geom="bar") + stat_summary(fun.data=mean_cl_normal, geom="errorbar", width=0.2) + facet_wrap(~ gender) + labs(x="Film", y="Mean Arousal") + theme(legend.position="none")