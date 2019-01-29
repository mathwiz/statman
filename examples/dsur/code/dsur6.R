projectDir <- "/Users/yohanlee/Dev/GitHub/statman/examples/dsur"
setwd(file.path(projectDir, "code"))
getwd()
load(".RData")
ls()
dataDir <- file.path(projectDir, "data")


library(ggplot2)
library(Hmisc)
library(Rcmdr)
library(boot)
library(polycor)
library(ggm)


## Adverts ~ Toffee data set
adverts <- c(5,4,4,6,8)
packets <- c(8,9,10,13,15)
advertData <- data.frame(adverts, packets)
head(advertData)
describe(advertData)

scatter <- ggplot(advertData, aes(adverts, packets))
scatter + geom_point(position="jitter") + geom_smooth(method="lm", alpha=0.3)


## Exam data
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


## Biggest Liar data set
liarData <- read.delim(file.path(dataDir, "The Biggest Liar.dat"), header=TRUE)
head(liarData)

cor(liarData$Position, liarData$Creativity, method="spearman")

liarMatrix <- as.matrix(liarData[, c("Position", "Creativity")])

rcorr(liarMatrix)

cor.test(liarData$Position, liarData$Creativity, method="spearman", alternative="less")

cor(liarData$Position, liarData$Creativity, method="kendall")

cor.test(liarData$Position, liarData$Creativity, method="kendall", alternative="less")

bootTau <- function(liarData, i) { cor(liarData$Position[i], liarData$Creativity[i], use="complete.obs", method="kendall") }

boot_kendall <- boot(liarData, bootTau, 2000)
boot_kendall
boot.ci(boot_kendall, conf=0.99)


# Cat data set
catData <- read.csv(file.path(dataDir, "pbcorr.csv"), header=TRUE)
head(catData)

cor(catData)
cor.test(catData$time, catData$gender, method="pearson")
cor.test(catData$time, catData$recode, method="pearson")

catFreq <- table(catData$gender)
prop.table(catFreq)

polyserial(catData$time, catData$gender)


# Partial Correlation Analysis
examData2 <- examData[, c("Exam", "Anxiety", "Revise")]

pc <- pcor(c("Exam", "Anxiety", "Revise"), var(examData2))

pc^2

pcor.test(pc, 1, 103) #103 sample size

