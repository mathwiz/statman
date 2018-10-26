library(ggplot2)
library(Hmisc)
library(reshape2)

chickFlick <- read.delim("ChickFlick.dat", header=TRUE)
head(chickFlick)

bar <- ggplot(chickFlick, aes(film, arousal))

bar + stat_summary(fun.y=mean, geom="bar", fill="White", colour="Black") + stat_summary(fun.data=mean_cl_normal, geom="pointrange") + labs(x="Film", y="Mean Arousal")

bar <- ggplot(chickFlick, aes(film, arousal, fill=gender))
bar + stat_summary(fun.y=mean, geom="bar", position="dodge") + stat_summary(fun.data=mean_cl_normal, geom="errorbar", position=position_dodge(width=0.90), width=0.2)

bar <- ggplot(chickFlick, aes(film, arousal, fill=film))
bar + stat_summary(fun.y=mean, geom="bar") + stat_summary(fun.data=mean_cl_normal, geom="errorbar", width=0.2) + facet_wrap(~ gender) + labs(x="Film", y="Mean Arousal") + theme(legend.position="none")

hiccupsData <- read.delim("Hiccups.dat", header=TRUE)
head(hiccupsData)
hiccups <- stack(hiccupsData)
names(hiccups) <- c("Hiccups", "Intervention")
head(hiccups)
levels(hiccups$Intervention)
hiccups$Intervention_Factor <- factor(hiccups$Intervention, levels=unique(hiccups$Intervention))

line <- ggplot(hiccups, aes(Intervention_Factor, Hiccups))
line + stat_summary(fun.y=mean, geom="point") + stat_summary(fun.y=mean, geom="line", aes(group=1), colour="Blue", linetype="dashed") + stat_summary(fun.data=mean_cl_normal, geom="errorbar", width=0.2, colour="Red") + labs(x="Intervention", y="Mean Number of Hiccups")

ggsave("Hiccups_Line.png")

textData <- read.delim("TextMessages.dat", header=TRUE)
head(textData)
textMessages <- melt(textData, id=c("Group"), measured=c("Baseline", "Six_months"))
names(textMessages) <- c("Group", "Time", "Grammar_Score")
textMessages$Time_Factor <- factor(textMessages$Time, levels=unique(textMessages$Time))
head(textMessages)
line <- ggplot(textMessages, aes(Time, Grammar_Score, colour=Group))
line + stat_summary(fun.y=mean, geom="point") + stat_summary(fun.y=mean, geom="line", aes(group=Group), linetype="dashed") + stat_summary(fun.data=mean_cl_normal, geom="errorbar", width=0.2) + labs(x="Time", y="Grammar Score", colour="Group")

ggsave("TextMessages_Line.png")