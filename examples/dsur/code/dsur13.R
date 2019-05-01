library(ez)
library(ggplot2)
library(multcomp)
library(nlme)
library(WRS2)
library(pastecs)
library(reshape)


                                        # Bushtucker Data

bushDat<- read.delim(file.path(dataDir, "Bushtucker.dat"), header=TRUE)
head(bushDat)

                                        # Repeated measures ANOVA

longBush<- melt(bushDat, id="participant", measured=c("stick_insect", "kangaroo_testicle", "fish_eye", "witchetty_grub"))
names(longBush)<- c("Participant", "Animal", "Retch")
head(longBush, n=12)
longBush$Animal<- factor(longBush$Animal, labels=c("Stick Insect", "Kangaroo Testicle", "Fish Eye", "Witchetty Grub"))
PartVsWhole<- c(1,-1,-1,1)
TesticleVsEye<- c(0,-1,1,0)
StickVsGrub<- c(-1,0,0,1)
contrasts(longBush$Animal)<- cbind(PartVsWhole, TesticleVsEye, StickVsGrub)
longBush$Animal


                                        # ezANOVA

bushModel<- ezANOVA(data=longBush, dv=.(Retch), wid=.(Participant), within=.(Animal), detailed=TRUE, type=3)
bushModel
pairwise.t.test(longBush$Retch, longBush$Animal, paired=TRUE, p.adjust.method="bonferroni")


                                        # Multilevel approach

multModel<- lme(Retch ~ Animal, random = ~1|Participant/Animal, data=longBush, method="ML")
baseModel<- lme(Retch ~ 1, random = ~1|Participant/Animal, data=longBush, method="ML")

anova(baseModel, multModel)
summary(multModel)

postHocs<- glht(multModel, linfct=mcp(Animal="Tukey"))
summary(postHocs)
confint(postHocs)


                                        # Robust approaches

robust<- rmanova(longBush$Retch, longBush$Animal, longBush$Participant)
robust
rmmcp(longBush$Retch, longBush$Animal, longBush$Participant)

robustBoot<- rmanovab(longBush$Retch, longBush$Animal, longBush$Participant, nboot=2000)
robustBoot
pairdepb(longBush$Retch, longBush$Animal, longBush$Participant, nboot=2000)


                                        # Factorial repeated measures ANOVA

attitudeDat<- read.delim(file.path(dataDir, "Attitude.dat"), header=TRUE)
head(attitudeDat)

longAttitude<- melt(attitudeDat, id="participant", measured=c("beerpos", "beerneg", "beerneut", "winepos", "wineneg", "wineneut", "waterpos", "waterneg", "waterneut"))
names(longAttitude)<- c("participant", "groups", "attitude")
longAttitude$drink<- gl(3, 60, labels=c("Beer", "Wine", "Water"))
longAttitude$imagery<- gl(3, 20, 180, labels=c("Positive", "Negative", "Neutral"))
head(longAttitude, n=30)

by(longAttitude$attitude, list(longAttitude$drink, longAttitude$imagery), stat.desc, basic=FALSE)

AlcoholVsWater<- c(1,1,-2)
BeerVsWine<- c(-1,1,0)
contrasts(longAttitude$drink)<- cbind(AlcoholVsWater, BeerVsWine)
longAttitude$drink

NegativeVsOther<- c(1,-2,1)
PositiveVsNeutral<- c(-1,0,1)
contrasts(longAttitude$imagery)<- cbind(NegativeVsOther, PositiveVsNeutral)
longAttitude$imagery

attitudeModel<- ezANOVA(data=longAttitude, dv=.(attitude), wid=.(participant), within=.(imagery, drink), type=3, detailed=TRUE)
attitudeModel
pairwise.t.test(longAttitude$attitude, longAttitude$groups, paired=TRUE, p.adjust.method="bonferroni")

baseline<- lme(attitude ~ 1, random = ~1|participant/drink/imagery, data=longAttitude, method="ML")
drinkM<- update(baseline, .~. + drink)
imageryM<- update(drinkM, .~. + imagery)
attitudeM<- update(imageryM, .~. + drink:imagery)

anova(baseline, drinkM, imageryM, attitudeM)
summary(attitudeM)

