library(ez)
library(ggplot2)
library(nlme)
library(WRS2)
library(pastecs)
library(reshape)


                                        # Mixed design ANOVA

dateDat<- read.delim(file.path(dataDir, "LooksOrPersonality.dat"), header=TRUE)
speedDat<- melt(dateDat, id=c("participant", "gender"), measured=c("att_high", "av_high", "ug_high", "att_some", "av_some", "ug_some", "att_none", "av_none", "ug_none"))
names(speedDat)<- c("participant", "gender", "groups", "dateRating")
speedDat$personality<- gl(3, 60, labels=c("Charismatic", "Average", "Dullard"))
speedDat$looks<- gl(3, 20, 180, labels=c("Attractive", "Average", "Ugly"))
head(speedDat, n=30)

by(speedDat$dateRating, list(speedDat$looks, speedDat$personality, speedDat$gender), stat.desc, basic=FALSE)

HiVsAv<- c(1,0,0)
DullVsAv<- c(0,0,1)
contrasts(speedDat$personality)<- cbind(HiVsAv, DullVsAv)
AttractiveVsAv<- c(1,0,0)
UglyVsAv<- c(0,0,1)
contrasts(speedDat$looks)<- cbind(AttractiveVsAv, UglyVsAv)
speedDat$looks
speedDat$personality

baseline<- lme(dateRating ~ 1, random = ~1|participant/looks/personality, data=speedDat, method="ML")
looksM<- update(baseline, .~. + looks)
personalityM<- update(looksM, .~. + personality)
genderM<- update(personalityM, .~. + gender)
looks_gender<- update(genderM, .~. + looks:gender)
personality_gender<- update(looks_gender, .~. + personality:gender)
looks_personality<- update(personality_gender, .~. + looks:personality)
speedDateModel<- update(looks_personality, .~. + looks:personality:gender)

anova(baseline, looksM, personalityM, genderM, looks_gender, personality_gender, looks_personality, speedDateModel)
summary(speedDateModel)


                                        # Robust methods for mixed designs

pictureDat<- read.delim(file.path(dataDir, "ProfilePicture.dat"), header=TRUE)
head(pictureDat, n=20)

pictureLong <- reshape(pictureDat, direction = "long", varying = list(3:4), idvar = "case", timevar = c("pictype"), times = c("couple", "alone"))
colnames(pictureLong)[4] <- "friend_requests"
head(pictureLong, n=20)

## 2-way within-between subjects ANOVA
bwtrim(friend_requests ~ relationship_status*pictype, id = case, data = pictureLong)

## between groups effect only (MOM estimator)
sppba(friend_requests ~ relationship_status*pictype, case, data = pictureLong)

## within groups effect only (MOM estimator)
sppbb(friend_requests ~ relationship_status*pictype, case, data = pictureLong)

## interaction effect only (MOM estimator)
sppbi(friend_requests ~ relationship_status*pictype, case, data = pictureLong)

