library(dplyr)
library(FNN)
library(caret)
library(ISLR)


trimCols<- function(df) {
    return( df[c("Season", "Rk", "Player", "Age", "G", "DKPt", "PaTDPG", "RuTDPG", "ReTDPG", "PaYPG", "RuYPG", "ReYPG", "PaAPG", "RuAPG", "ReRPG", "NextDKG")] )
}


## wrangle data for knn
names(qbDat)
qbTrim<- trimCols(qbDat)
head(qbTrim)
summary(qbTrim$Season)
summary(qbTrim$Age)
nrow(qbTrim)


## add standardized variables
stdCols<- c("PaTDPG", "RuTDPG", "ReTDPG", "PaYPG", "RuYPG", "ReYPG", "PaAPG", "RuAPG", "ReRPG")
qbCols<- c("Age", "PaTDPG", "RuTDPG", "PaYPG", "RuYPG", "PaAPG", "RuAPG")
qbModelCols <- paste("std", qbCols, sep=".")
qbModelCols
qbStd<- scale(qbTrim[qbCols])
head(qbTrim[qbCols])
head(qbStd)

# no need for this, use scale
standardize<- function(frame, colNames) {
    augmented<- frame
    for (col in colNames) {
        newCol<- paste("std", col, sep=".")
        augmented[,newCol]<- scale(frame[,col])
    }
    return(augmented)
}

qbAug<- standardize(qbTrim[qbCols], qbCols)
head(qbAug)

   
## split dataframes
season.2017<- qbStd$Season == 2017
season.2018<- qbStd$Season == 2018
train<- !(season.2017 | season.2018)
summary(season.2017)
summary(season.2018)
summary(train)
qbTrain<- qbStd[train, ]
head(qbTrain)
qb.2017<- qbStd[season.2017, ]
head(qb.2017)
qb.2018<- qbStd[season.2018, ]
head(qb.2018)

## get the response values
outcome <- qbTrim["NextDKG"]
head(outcome)
train.out <- outcome[train, ]
str(train.out)


## Models

qbModel.2017 <- knn.reg(train=qbTrain, test=qb.2017, y=train.out, k=5)
qbModel.2018 <- knn.reg(train=qbTrain[qbModelCols], test=qb.2018[qbModelCols], y=qbTrain$NextDKG, k=5)
summary(qbModel.2017)
qb.2017$pred <- qbModel.2017$pred
qb.2018$pred <- qbModel.2018$pred
head(qb.2017[,c("Player", "NextDKG", "pred")], n=24)
head(qb.2018[,c("Player", "DKPt", "pred")], n=24)


rbModel<- lm(NextDKG ~ Age + RuAPG + RuYPG + RuTDPG + ReRPG + ReTDPG, data=rbDat, na.action=na.exclude)
summary(rbModel)

wrModel<- lm(NextDKG ~ Age + ReRPG + ReYPG + ReTDPG, data=wrDat, na.action=na.exclude)
summary(wrModel)

teModel<- lm(NextDKG ~ Age + ReRPG + ReTDPG, data=teDat, na.action=na.exclude)
summary(teModel)


# Prediction
addPrediction<- function(data, model, season, n) {
	newDat<- data[which(data$Season==season), ]
	newDat$DKPG<- newDat$DKPt / newDat$G 
	newDat$fit<- predict(model, newDat, interval="predict")[,1]
	newDat<- top_n(newDat, n*2, newDat$DKPG)
	avgPrediction<- mean(newDat$fit)
	newDat$differential<- newDat$fit - avgPrediction
	return(newDat)
}

qb2018<- addPrediction(qbDat, qbModel, 2018, 16)
dplyr::select(qb2018, Player, DKPt, DKPG, fit, differential)[order(-qb2018$fit), ]
