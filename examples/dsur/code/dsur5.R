projectDir <- "c:/Users/Yohan/Documents/GitHub/statman/examples/dsur"
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
library(Rcmdr)


# Download Festival data set
dlf <- read.delim(file.path(dataDir, "DownloadFestival(No Outlier).dat"), header=TRUE)
head(dlf)
dlf[1:1, c("ticknumb", "gender")]
dlf$day1_log <- log(dlf$day1 + 1)
dlf$day2_log <- log(dlf$day2 + 1)
dlf$day3_log <- log(dlf$day3 + 1)
describe(dlf)

HistDay1 <- ggplot(dlf, aes(day1)) + theme(legend.position="none") + geom_histogram(aes(y=..density..), colour="Black", fill="White") + labs(x="Hygiene Score Day 1", y="Density")
HistDay1 + stat_function(fun=dnorm, args=list(mean=mean(dlf$day1, na.rm=TRUE), sd=sd(dlf$day1, na.rm=TRUE)), colour="Black", size=1)

ggplot(dlf, aes(day2)) + theme(legend.position="none") + geom_histogram(aes(y=..density..), colour="Black", fill="White") + labs(x="Hygiene Score Day 2", y="Density") + stat_function(fun=dnorm, args=list(mean=mean(dlf$day2, na.rm=TRUE), sd=sd(dlf$day2, na.rm=TRUE)), colour="Black", size=1)

ggplot(dlf, aes(day3)) + theme(legend.position="none") + geom_histogram(aes(y=..density..), colour="Black", fill="White") + labs(x="Hygiene Score Day 3", y="Density") + stat_function(fun=dnorm, args=list(mean=mean(dlf$day3, na.rm=TRUE), sd=sd(dlf$day3, na.rm=TRUE)), colour="Black", size=1)

ggplot(dlf, aes(day1_log)) + theme(legend.position="none") + geom_histogram(aes(y=..density..), colour="Black", fill="White") + labs(x="Log Hygiene Score Day 1", y="Density") + stat_function(fun=dnorm, args=list(mean=mean(dlf$day1_log, na.rm=TRUE), sd=sd(dlf$day1_log, na.rm=TRUE)), colour="Black", size=1)

ggplot(dlf, aes(day2_log)) + theme(legend.position="none") + geom_histogram(aes(y=..density..), colour="Black", fill="White") + labs(x="Log Hygiene Score Day 2", y="Density") + stat_function(fun=dnorm, args=list(mean=mean(dlf$day2_log, na.rm=TRUE), sd=sd(dlf$day2_log, na.rm=TRUE)), colour="Black", size=1)

ggplot(dlf, aes(day3_log)) + theme(legend.position="none") + geom_histogram(aes(y=..density..), colour="Black", fill="White") + labs(x="Log Hygiene Score Day 3", y="Density") + stat_function(fun=dnorm, args=list(mean=mean(dlf$day3_log, na.rm=TRUE), sd=sd(dlf$day3_log, na.rm=TRUE)), colour="Black", size=1)

QQDay1 <- ggplot(dlf, aes(sample=day1)) + stat_qq(colour="Blue")
QQDay2 <- ggplot(dlf, aes(sample=day2)) + stat_qq(colour="Blue")
QQDay3 <- ggplot(dlf, aes(sample=day3)) + stat_qq(colour="Blue")

ggsave("QQDay1.png")

describe(cbind(dlf$day1, dlf$day2, dlf$day3))
describe(dlf[, c("day1", "day2", "day3")])

round(stat.desc(dlf[, c("day1", "day2", "day3")], basic=FALSE, norm=TRUE), digits=3)

rowMeans(cbind(dlf$day1, dlf$day2, dlf$day3))
dlf$meanHygiene <- rowMeans(cbind(dlf$day1, dlf$day2, dlf$day3), na.rm=TRUE)
describe(dlf$meanHygiene)
l
# R Exam data set
rexam <- read.delim(file.path(dataDir, "RExam.dat"), header=TRUE)
rexam$uni <- factor(rexam$uni, levels=c(0,1), labels=c("Duncetown University", "Sussex University"))
head(rexam)
rexam$exam_log <- log(rexam$exam)
describe(rexam)

by(data=rexam$exam, INDICES=rexam$uni, FUN=describe)

by(data=rexam$exam, INDICES=rexam$uni, FUN=stat.desc)

by(cbind(data=rexam$exam, data=rexam$numeracy), rexam$uni, describe)

by(rexam[, c("exam", "numeracy")], rexam$uni, stat.desc, basic=FALSE, norm=TRUE)

dunceData <- subset(rexam, rexam$uni == "Duncetown University")
sussexData <- subset(rexam, rexam$uni == "Sussex University")


hist.numeracy.duncetown <- ggplot(dunceData, aes(numeracy)) + theme(legend.position="none") + geom_histogram(aes(y=..density..), fill="White", colour="Black", binwidth=1) + labs(x="Numeracy Score", y="Density") + stat_function(fun=dnorm, args=list(mean=mean(dunceData$numeracy, na.rm=TRUE), sd=sd(dunceData$numeracy, na.rm=TRUE)), colour="Blue", size=1)

hist.numeracy.sussex <- ggplot(sussexData, aes(numeracy)) + theme(legend.position="none") + geom_histogram(aes(y=..density..), fill="White", colour="Black", binwidth=1) + labs(x="Numeracy Score", y="Density") + stat_function(fun=dnorm, args=list(mean=mean(sussexData$numeracy, na.rm=TRUE), sd=sd(sussexData$numeracy, na.rm=TRUE)), colour="Blue", size=1)

