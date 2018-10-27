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


dlf <- read.delim(file.path(dataDir, "DownloadFestival(No Outlier).dat"), header=TRUE)
head(dlf)
dlf[1:1, c("ticknumb", "gender")]

HistDay1 <- ggplot(dlf, aes(day1)) + theme(legend.position="none") + geom_histogram(aes(y=..density..), colour="Black", fill="White") + labs(x="Hygiene Score Day 1", y="Density")
HistDay1 + stat_function(fun=dnorm, args=list(mean=mean(dlf$day1, na.rm=TRUE), sd=sd(dlf$day1, na.rm=TRUE)), colour="Black", size=1)

ggplot(dlf, aes(day2)) + theme(legend.position="none") + geom_histogram(aes(y=..density..), colour="Black", fill="White") + labs(x="Hygiene Score Day 2", y="Density") + stat_function(fun=dnorm, args=list(mean=mean(dlf$day1, na.rm=TRUE), sd=sd(dlf$day1, na.rm=TRUE)), colour="Black", size=1)

ggplot(dlf, aes(day3)) + theme(legend.position="none") + geom_histogram(aes(y=..density..), colour="Black", fill="White") + labs(x="Hygiene Score Day 3", y="Density") + stat_function(fun=dnorm, args=list(mean=mean(dlf$day1, na.rm=TRUE), sd=sd(dlf$day1, na.rm=TRUE)), colour="Black", size=1)

QQDay1 <- ggplot(dlf, aes(sample=day1)) + stat_qq(colour="Blue")
QQDay2 <- ggplot(dlf, aes(sample=day2)) + stat_qq(colour="Blue")
QQDay3 <- ggplot(dlf, aes(sample=day3)) + stat_qq(colour="Blue")

ggsave("QQDay1.png")

describe(cbind(dlf$day1, dlf$day2, dlf$day3))
describe(dlf[, c("day1", "day2", "day3")])

round(stat.desc(dlf[, c("day1", "day2", "day3")], basic=FALSE, norm=TRUE), digits=3)

rexam <- read.delim(file.path(dataDir, "RExam.dat"), header=TRUE)
rexam$uni <- factor(rexam$uni, levels=c(0,1), labels=c("Duncetown University", "Sussex University"))
head(rexam)
describe(rexam)

by(data=rexam$exam, INDICES=rexam$uni, FUN=describe)

