library(car)
library(mlogit)

                                        # Eel data

eelData<- read.delim(file.path(dataDir, "eel.dat"), header=TRUE)
summary(eelData)

eelData$Cured<- relevel(eelData$Cured, "Not Cured")
eelData$Intervention<- relevel(eelData$Intervention, "No Treatment")

eelModel.1<- glm(Cured ~ Intervention, data=eelData, family=binomial())
summary(eelModel.1)
exp(eelModel.1$coefficients) # Odds ratios
exp(confint(eelModel.1)) # Confidence intervals

eelModel.2<- glm(Cured ~ Intervention + Duration, data=eelData, family=binomial())
summary(eelModel.2)
exp(eelModel.2$coefficients) # Odds ratios
exp(confint(eelModel.2)) # Confidence intervals

anova(eelModel.1, eelModel.2)

cat("Residual analysis")
eelData$predicted<- fitted(eelModel.1)
eelData$std.resid<- rstandard(eelModel.1)
eelData$stu.resid<- rstudent(eelModel.1)
eelData$dfbeta<- dfbeta(eelModel.1)
eelData$dffits<- dffits(eelModel.1)
eelData$leverage<- hatvalues(eelModel.1)

head(eelData[, c("Cured", "Intervention", "Duration", "predicted")])
eelData[, c("leverage", "stu.resid", "dfbeta")]


                                        # Penalty data
penaltyData<- read.delim(file.path(dataDir, "penalty.dat"), header=TRUE)
summary(penaltyData)

penaltyModel.1<- glm(Scored ~ Previous, data=penaltyData, family=binomial())
summary(penaltyModel.1)

penaltyModel.2<- glm(Scored ~ Previous + PSWQ + Anxious, data=penaltyData, family=binomial())
summary(penaltyModel.2)

1/vif(penaltyModel.2)

penaltyData$logPSWQInt<- log(penaltyData$PSWQ) * penaltyData$PSWQ
penaltyData$logAnxiousInt<- log(penaltyData$Anxious) * penaltyData$Anxious
penaltyData$logPreviousInt<- log(penaltyData$Previous) * penaltyData$Previous

penaltyTest.1<- glm(Scored ~ Previous + PSWQ + Anxious + logPreviousInt + logPSWQInt + logAnxiousInt, data=penaltyData, family=binomial())
summary(penaltyTest.1)


                                        # Chat-up lines data
chatData<- read.delim(file.path(dataDir, "Chat-Up Lines.dat"), header=TRUE)
summary(chatData)

chatData$Gender<- relevel(chatData$Gender, ref=2) # make Male baseline

mlChat<- mlogit.data(chatData, choice="Success", shape="wide") # reshape multiple logit
summary(mlChat)

chatModel<- mlogit(Success ~ 1 | Good_Mate + Funny + Gender + Sex + Gender:Sex + Funny:Gender, data=mlChat, reflevel=3)
summary(chatModel)
data.frame(exp(chatModel$coefficients))
exp(confint(chatModel))

