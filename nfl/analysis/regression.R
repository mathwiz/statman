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

rows<- qb2018[1:12,]
rows<- qbDat[sample(nrow(qbDat), 10), ]
rows
predict(qbModel, rows, interval="predict")

rows<- rb2018[1:12,]
rows<- rbDat[sample(nrow(rbDat), 10), ]
rows
predict(rbModel, rows, interval="predict")

rows<- wr2018[1:12,]
rows<- wrDat[sample(nrow(wrDat), 10), ]
rows
predict(wrModel, rows, interval="predict")

rows<- te2018[1:12,]
rows<- teDat[sample(nrow(teDat), 10), ]
rows
predict(teModel, rows, interval="predict")


