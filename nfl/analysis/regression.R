library(dplyr)

dataDir<- "../data"

qbDat<- read.csv(file.path(dataDir, "qb.csv"), header=TRUE)
head(qbDat)

rbDat<- read.csv(file.path(dataDir, "rb.csv"), header=TRUE)
head(rbDat)

wrDat<- read.csv(file.path(dataDir, "wr.csv"), header=TRUE)
head(wrDat)

teDat<- read.csv(file.path(dataDir, "te.csv"), header=TRUE)
head(teDat)


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

rb2018<- addPrediction(rbDat, rbModel, 2018, 32)
dplyr::select(rb2018, Player, DKPt, DKPG, fit, differential)[order(-rb2018$fit), ]

wr2018<- addPrediction(wrDat, wrModel, 2018, 32)
dplyr::select(wr2018, Player, DKPt, DKPG, fit, differential)[order(-wr2018$fit), ]

te2018<- addPrediction(teDat, teModel, 2018, 16)
dplyr::select(te2018, Player, DKPt, DKPG, fit, differential)[order(-te2018$fit), ]


