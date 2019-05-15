library(gmodels)
library(MASS)


                                        # Categorical analysis

catDat<- read.delim(file.path(dataDir, "cats.dat"), header=TRUE)
str(catDat)
CrossTable(catDat$Training, catDat$Dance, fisher=TRUE, chisq=TRUE, expected=TRUE, sresid=TRUE, format="SAS")

catTable<- cbind(c(10, 28), c(114, 48))
catTable
CrossTable(catTable, fisher=TRUE, chisq=TRUE, expected=TRUE, sresid=TRUE, format="SAS")


                                        # Loglinear analysis

catsDogs<- read.delim(file.path(dataDir, "CatsAndDogs.dat"), header=TRUE)
str(catsDogs)

table(catsDogs)

justCats<- subset(catsDogs, Animal=="Cat")
justDogs<- subset(catsDogs, Animal=="Dog")

CrossTable(justCats$Training, justCats$Dance, sresid=TRUE, prop.t=FALSE, prop.c=FALSE, prop.chisq=FALSE, format="SPSS")
CrossTable(justDogs$Training, justDogs$Dance, sresid=TRUE, prop.t=FALSE, prop.c=FALSE, prop.chisq=FALSE, format="SPSS")

catTable<- xtabs(~ Training + Dance, data=justCats)
catTable

dogTable<- xtabs(~ Training + Dance, data=justDogs)
dogTable

catSaturated<- loglm(~ Training + Dance + Training:Dance, data=catTable, fit=TRUE)
catSaturated
catNoInteraction<- loglm(~ Training + Dance, data=catTable, fit=TRUE)
catNoInteraction

par(mfrow=c(2,2))
mosaicplot(catSaturated$fit, shade=TRUE, main="Cats: Saturated Model")
mosaicplot(catNoInteraction$fit, shade=TRUE, main="Cats: Expected Values")


CatDogTable<- xtabs(~ Animal + Training + Dance, data=catsDogs)

saturated<- loglm(~ Animal*Training*Dance, data=CatDogTable)
summary(saturated)

threeWay<- loglm(~ Animal + Training + Dance + Animal:Training + Animal:Dance + Training:Dance, data=CatDogTable)
summary(threeWay)

anova(saturated, threeWay)

mosaicplot(CatDogTable, shade=TRUE, main="Cats and Dogs")
