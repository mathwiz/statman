library(car)
library(ggplot2)
library(nlme)
library(reshape)


                                        # Hierarchical regression

surgeryDat<- read.delim(file.path(dataDir, "Cosmetic Surgery.dat"), header=TRUE)
str(surgeryDat)
head(surgeryDat)


                                        # Simple linear models

surgeryLinearModel<- lm(Post_QoL ~ Surgery, data=surgeryDat)
summary(surgeryLinearModel)

surgeryAncova<- lm(Post_QoL ~ Surgery + Base_QoL, data=surgeryDat)
summary(surgeryAncova)


                                        # Assess need for multi-level models

interceptOnly<- gls(Post_QoL ~ 1, data=surgeryDat, method="ML")
summary(interceptOnly)

randomInterceptOnly<- lme(Post_QoL ~ 1, data=surgeryDat, random = ~ 1 | Clinic, method="ML")
summary(randomInterceptOnly)

logLik(interceptOnly) * -2
logLik(randomInterceptOnly) * -2
change<- 2013.12 - 1905.47 # chisq(df=1)=107.65 (p<0.05)
anova(interceptOnly, randomInterceptOnly)


## Adding fixed effects

randomInterceptSurgery<- lme(Post_QoL ~ Surgery, data=surgeryDat, random = ~ 1 | Clinic, method="ML")
summary(randomInterceptSurgery)

randomInterceptSurgeryQoL<- lme(Post_QoL ~ Surgery + Base_QoL, data=surgeryDat, random = ~ 1 | Clinic, method="ML")
summary(randomInterceptSurgeryQoL)

anova(randomInterceptOnly, randomInterceptSurgery, randomInterceptSurgeryQoL)


## Introducing random slopes

addRandomSlope<- lme(Post_QoL ~ Surgery + Base_QoL, data=surgeryDat, random = ~ Surgery | Clinic, method="ML")
summary(addRandomSlope)
anova(randomInterceptSurgeryQoL, addRandomSlope)


## Adding an interaction term

addReason<- update(addRandomSlope, .~. + Reason)
summary(addReason)

finalModel<- update(addReason, .~. + Reason:Surgery)
summary(finalModel)

anova(addRandomSlope, addReason, finalModel)


## Examine model

intervals(finalModel, 0.90)
intervals(finalModel, 0.95)
intervals(finalModel, 0.99)


                                        # Growth Models

honeymoonDat<- read.delim(file.path(dataDir, "Honeymoon Period.dat"), header=TRUE)
str(honeymoonDat)
head(honeymoonDat)

restructuredDat<- melt(honeymoonDat, id=c("Person", "Gender"), measured=c("Satisfaction_Base", "Satisfaction_6_Months", "Satisfaction_12_Months", "Satisfaction_18_Months"))
names(restructuredDat)[3]<- "Time"
names(restructuredDat)[4]<- "Life_Satisfaction"
restructuredDat$Time<-as.numeric(restructuredDat$Time)-1

head(restructuredDat)
str(restructuredDat)


intercept<- gls(Life_Satisfaction ~ 1, data=restructuredDat, method="ML", na.action=na.exclude)
summary(intercept)

randomIntercept<- lme(Life_Satisfaction ~ 1, data=restructuredDat, random=~1|Person, method="ML", na.action=na.exclude, control=c("optim"))
summary(randomIntercept)

timeRI<- update(randomIntercept, .~. + Time)
summary(timeRI)

timeRS<- update(timeRI, random= ~ Time | Person)
summary(timeRS)


ARModel<-lme(Life_Satisfaction~Time, data = restructuredDat, random = ~Time|Person, correlation = corAR1(0, form = ~Time|Person), method = "ML", na.action = na.exclude, control = list(opt="optim"))
summary(ARModel)

anova(intercept, randomIntercept, timeRI, timeRS, ARModel)
summary(ARModel)
intervals(ARModel)

timeQuadratic<-lme(Life_Satisfaction~Time + I(Time^2), data = restructuredDat, random = ~Time|Person, correlation = corAR1(0, form = ~Time|Person), method = "ML", na.action = na.exclude, control = list(opt="optim"))
summary(timeQuadratic)

timeCubic <-lme(Life_Satisfaction~Time + I(Time^2) + I(Time^3), data = restructuredDat, random = ~Time|Person, correlation = corAR1(0, form = ~Time|Person), method = "ML", na.action = na.exclude, control = list(opt="optim"))
summary(timeCubic)
intervals(timeCubic)

polyModel<-lme(Life_Satisfaction~poly(Time, 3), data = restructuredDat, random = ~Time|Person, correlation = corAR1(0, form = ~Time|Person), method = "ML", na.action = na.exclude, control = list(opt="optim"))
summary(polyModel)

anova(intercept, randomIntercept, timeRI, timeRS, ARModel, timeQuadratic, timeCubic)


