library(ggplot2)
library(pastecs)
library(WRS2)


                                        # Spider data
spiderLong<- read.delim(file.path(dataDir,"SpiderLong.dat"), header=TRUE)
summary(spiderLong)

spiderWide<- read.delim(file.path(dataDir,"SpiderWide.dat"), header=TRUE)
summary(spiderWide)

by(spiderLong$Anxiety, spiderLong$Group, stat.desc, basic=FALSE, norm=TRUE)
