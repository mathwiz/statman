library(dplyr)
library(FNN)
library(caret)
library(ISLR)


trimCols<- function(df) {
    return( df[c("Season", "Rk", "Player", "Age", "G", "DKPt", "PaTDPG", "RuTDPG", "ReTDPG", "PaYPG", "RuYPG", "ReYPG", "PaAPG", "RuAPG", "ReRPG", "NextDKG")] )
}

fiftyFiftySplit<- function(df) {
    sample.int(nrow(df), nrow(df)/2)
}


## wrangle data for knn
names(qbDat)
qbTrim<- trimCols(qbDat)
head(qbTrim)
summary(qbTrim$Season)
summary(qbTrim$Age)
nrow(qbTrim)


## add standardized variables
stdCols<- c("DKPt", "PaTDPG", "RuTDPG", "ReTDPG", "PaYPG", "RuYPG", "ReYPG", "PaAPG", "RuAPG", "ReRPG", "NextDKG")
qbStd<- scale(qbTrim[stdCols])
head(qbTrim[stdCols])
head(qbStd[,1])
paste("std", stdCols[1], sep=".")

standardize<- function(frame, colNames) {
    augmented<- frame
    for (col in colNames) {
        newCol<- paste("std", col, sep=".")
        augmented[,newCol]<- scale(frame[,col])
    }
    return(augmented)
}

qbAug<- standardize(qbTrim, stdCols)
head(qbAug)

   
## split dataframes
season.2017<- qbTrim$Season == 2017
season.2018<- qbTrim$Season == 2018
train<- !(season.2017 | season.2018)
summary(season.2017)
summary(season.2018)
summary(train)
qbTrain<- qbTrim[train, ]
nrow(qbTrain)
qb.2017<- qbTrim[season.2017, ]
nrow(qb.2017)
qb.2018<- qbTrim[season.2018, ]
nrow(qb.2018)


# Models

qbModel<- lm(NextDKG ~ Age + PaYPG + PaTDPG + RuYPG + RuTDPG, data=qbDat, na.action=na.exclude)
summary.lm(qbModel)

wrModel<- lm(NextDKG ~ Age + ReRPG + ReYPG + ReTDPG, data=wrDat, na.action=na.exclude)
summary.lm(wrModel)

teModel<- lm(NextDKG ~ Age + ReRPG + ReTDPG, data=teDat, na.action=na.exclude)
summary.lm(teModel)

rbModel<- lm(NextDKG ~ Age + RuAPG + RuYPG + RuTDPG + ReRPG + ReTDPG, data=rbDat, na.action=na.exclude)
summary.lm(rbModel)


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
