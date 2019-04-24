library(ggplot2)
library(pastecs)
library(WRS2)


                                        # Spider data
spiderLong<- read.delim(file.path(dataDir,"SpiderLong.dat"), header=TRUE)
summary(spiderLong)

spiderWide<- read.delim(file.path(dataDir,"SpiderWide.dat"), header=TRUE)
summary(spiderWide)

by(spiderLong$Anxiety, spiderLong$Group, stat.desc, basic=FALSE, norm=TRUE)

regression<- lm(Anxiety ~ Group, data=spiderLong)
summary(regression)

ind.t.test<- t.test(Anxiety ~ Group, data=spiderLong)
ind.t.test

ind.t.test.2<- t.test(spiderWide$real, spiderWide$picture)
ind.t.test.2

trimmed<- yuen(Anxiety ~ Group, data=spiderLong, tr=.1)
trimmed

trimmedboot<- yuenbt(Anxiety ~ Group, data=spiderLong, tr=.1, nboot=2000)
trimmedboot

m.estimator<- pb2gen(Anxiety ~ Group, data=spiderLong, nboot=2000)
m.estimator

                                        # now consider frames to represent paired data

dep.t.test<- t.test(spiderWide$real, spiderWide$picture, paired=TRUE)
dep.t.test 

dep.t.test.2<- t.test(Anxiety ~ Group, data=spiderLong, paired=TRUE)
dep.t.test.2

dep.trimmed<- yuend(spiderWide$real, spiderWide$picture, tr=.2)
dep.trimmed


