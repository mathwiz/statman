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
qb2018<- qbDat[which(qbDat$Season==2018),]
head(qb2018)
rb2018<- rbDat[which(rbDat$Season==2018),]
head(rb2018)
wr2018<- wrDat[which(wrDat$Season==2018),]
head(wr2018)
te2018<- teDat[which(teDat$Season==2018),]
head(te2018)

predict(wrModel, wr2018[1:5], interval="predict")
wr