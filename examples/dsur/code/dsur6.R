projectDir <- "c:/Users/Yohan/Documents/GitHub/statman/examples/dsur"
setwd(file.path(projectDir, "code"))
getwd()
load(".RData")
ls()
dataDir <- file.path(projectDir, "data")


library(ggplot2)
library(Hmisc)
library(Rcmdr)


# Adverts ~ Toffee data set
adverts <- c(5,4,4,6,8)
packets <- c(8,9,10,13,15)
advertData <- data.frame(adverts, packets)
head(advertData)
describe(advertData)

scatter <- ggplot(advertData, aes(adverts, packets))
scatter + geom_point(position="jitter") + geom_smooth(method="lm", alpha=0.3)


# Exam data
examData <- read.delim(file.path(dataDir, "Exam Anxiety.dat"), header=TRUE)
head(examData)

cor(examData$Exam, examData$Anxiety, use="complete.obs", method="spearman")

cor(examData$Exam, examData$Anxiety, use="complete.obs", method="pearson")

cor(examData$Exam, examData$Anxiety, use="pairwise.complete.obs", method="kendall")

rcorr(examData$Exam, examData$Anxiety, type="pearson")

cor.test(examData$Exam, examData$Anxiety, alternative="less", method="pearson", conf.level=0.99)
cor.test(examData$Exam, examData$Anxiety, alternative="two.sided", method="pearson", conf.level=0.99)
cor.test(examData$Exam, examData$Anxiety, alternative="greater", method="pearson", conf.level=0.99)

cor(examData[, c("Exam", "Anxiety", "Revise")])

Hmisc::rcorr(as.matrix(examData[, c("Exam", "Anxiety", "Revise")]))

# Calculate R^2 as percent shared variance
cor(examData[, c("Exam", "Anxiety", "Revise")])^2 * 100



