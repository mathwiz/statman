library(dplyr)
library(FNN)
library(caret)
library(ISLR)


trimCols<- function(df) {
    return( df[c("Season", "Rk", "Player", "Age", "G", "DKPt", "PaTDPG", "RuTDPG", "ReTDPG", "PaYPG", "RuYPG", "ReYPG", "PaAPG", "RuAPG", "ReRPG", "NextDKG")] )
}

trimRows <- function(df, currentSeason) {
    return(df[df$Season==currentSeason | !is.na(df$NextDKG),])
}


## wrangle data for knn
names(qbDat)
qbTrim<- trimRows(trimCols(qbDat), 2018)
tail(qbTrim)
summary(qbTrim$Age)
nrow(qbTrim)


## add standardized variables
qbCols<- c("Age", "PaTDPG", "RuTDPG", "PaYPG", "RuYPG", "PaAPG", "RuAPG")
head(qbTrim[qbCols])


## split dataframes
season.2017<- qbTrim$Season == 2017
season.2018<- qbTrim$Season == 2018
train<- !(season.2017 | season.2018)


knn.model <- function(frame, modelColumns, trainVec, testVec) {
    outcomes <- frame %>% dplyr::select(NextDKG)
    model <-  scale(frame[modelColumns])
    train.out <- outcomes[trainVec, ]
    train <- model[trainVec, ]
    test <- model[testVec, ]
    return(knn.reg(train=train, test=test, y=train.out, k=3))
}

make.predictions <- function(frame, modelCols, reportCols, trainVec, testVec) {
    predictFrame <- frame[testVec, ]
    model <- knn.model(frame, modelCols, trainVec, testVec)
    return(cbind(predictFrame[, reportCols], model$pred))
}


## Models
qbPredictions <- make.predictions(qbTrim, qbCols, c("Player", "DKPt", "NextDKG"), train, season.2017)
qbPredictions <- make.predictions(qbTrim, qbCols, c("Player", "DKPt", "NextDKG"), train, season.2018)
head(qbPredictions, n=20)


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
