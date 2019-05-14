library(dplyr)


# Models

qbModel<- lm(NextDKG ~ Age + PaYPG + PaAPG + RuYPG + RuTDPG + PaAPG:PaTDPG + PaAPG:PaYPG, data=qbDat, na.action=na.exclude)
summary.lm(qbModel)

wrModel<- lm(NextDKG ~ Age + ReRPG + ReYPG + ReTDPG + ReYPG:ReRPG, data=wrDat, na.action=na.exclude)
summary.lm(wrModel)

teModel<- lm(NextDKG ~ Age + ReRPG + ReTDPG + ReRPG:ReTDPG, data=teDat, na.action=na.exclude)
summary.lm(teModel)

rbModel<- lm(NextDKG ~ Age + RuAPG + RuYPG + RuTDPG + ReRPG + ReTDPG + RuAPG:ReRPG, data=rbDat, na.action=na.exclude)
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

qb2018<- addPrediction(qbDat, qbModel, 2018, 12)
dplyr::select(qb2018, Player, DKPt, DKPG, fit, differential)[order(-qb2018$fit), ]

rb2018<- addPrediction(rbDat, rbModel, 2018, 24)
dplyr::select(rb2018, Player, DKPt, DKPG, fit, differential)[order(-rb2018$fit), ]

wr2018<- addPrediction(wrDat, wrModel, 2018, 30)
dplyr::select(wr2018, Player, DKPt, DKPG, fit, differential)[order(-wr2018$fit), ]

te2018<- addPrediction(teDat, teModel, 2018, 12)
dplyr::select(te2018, Player, DKPt, DKPG, fit, differential)[order(-te2018$fit), ]


allPred<- rbind(rb2018, wr2018, te2018, qb2018)
dplyr::select(allPred, Player, DKPt, DKPG, fit, differential)[order(-allPred$differential), ]

