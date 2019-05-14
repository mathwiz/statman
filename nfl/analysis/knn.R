library(dplyr)
library(FNN)
library(caret)


trimCols<- function(df) {
	return( df[c("Season", "Rk", "Player", "Age", "G", "DKPt", "PaTDPG", "RuTDPG", "ReTDPG", "PaYPG", "RuYPG", "ReYPG", "PaAPG", "RuAPG", "ReRPG", "NextDKG")] )
}

trainingIndexes<- function(df) {
	sample.int(nrow(df), nrow(df)/2)
}


qbMain<- qbDat[which(qbDat$Season!=2018 & qbDat$DKPt > 32), ]
qb2018<- qbDat[which(qbDat$Season==2018 & qbDat$DKPt > 32), ]


qb_train<- trainingIndexes(qbMain)
qbTrain<- qbMain[qb_train, ]
qbTrain<- trimCols(qbTrain)
qbTest<- qbMain[-qb_train, ]
qbTest<- trimCols(qbTest)



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
