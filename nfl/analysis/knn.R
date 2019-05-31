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
rbTrim<- trimRows(trimCols(rbDat), 2018)
wrTrim<- trimRows(trimCols(wrDat), 2018)
teTrim<- trimRows(trimCols(teDat), 2018)
tail(teTrim)
summary(teTrim$Age)
nrow(teTrim)


## add standardized variables
qbCols<- c("Age", "PaTDPG", "RuTDPG", "PaYPG", "RuYPG", "PaAPG", "RuAPG")
rbCols <- c("Age", "RuTDPG", "RuYPG", "RuAPG", "ReTDPG", "ReYPG", "ReRPG")
wrCols <- c("Age", "ReTDPG", "ReYPG", "ReRPG")
teCols <- c("Age", "ReTDPG", "ReYPG", "ReRPG")
head(rbTrim[rbCols])


knn.model <- function(frame, modelColumns, trainVec, testVec) {
    outcomes <- frame %>% dplyr::select(NextDKG)
    model <-  scale(frame[modelColumns])
    train.out <- outcomes[trainVec, ]
    train <- model[trainVec, ]
    test <- model[testVec, ]
    return(knn.reg(train=train, test=test, y=train.out, k=5))
}

make.predictions <- function(frame, modelCols, reportCols, trainVec, testVec) {
    predictFrame <- frame[testVec, reportCols]
    model <- knn.model(frame, modelCols, trainVec, testVec)
    predictFrame$pred <- model$pred #cbind(predictFrame[, reportCols], model$pred)
    return(predictFrame)
}


## Models
reportCols <- c("Player", "DKPt", "NextDKG")
season.2017<- qbTrim$Season == 2017
season.2018<- qbTrim$Season == 2018
train<- !(season.2017 | season.2018)
qbPredictions <- make.predictions(qbTrim, qbCols, reportCols, train, season.2017)
qbPredictions <- make.predictions(qbTrim, qbCols, reportCols, train, season.2018)
head(qbPredictions, n=20)
qbReport<- add.differential(qbPredictions, 20)
dplyr::select(qbReport, Player, DKPt, NextDKG, fit, differential)[order(-qbReport$fit), ]


rb.season.2017<- rbTrim$Season == 2017
rb.season.2018<- rbTrim$Season == 2018
rb.train<- !(season.2017 | season.2018)
rbPredictions <- make.predictions(rbTrim, rbCols, reportCols, rb.train, rb.season.2017)
rbPredictions <- make.predictions(rbTrim, rbCols, reportCols, rb.train, rb.season.2018)
head(rbPredictions, n=40)
rbReport<- add.differential(rbPredictions, 20)
dplyr::select(rbReport, Player, DKPt, NextDKG, fit, differential)[order(-rbReport$fit), ]


wr.season.2017<- wrTrim$Season == 2017
wr.season.2018<- wrTrim$Season == 2018
wr.train<- !(season.2017 | season.2018)
wrPredictions <- make.predictions(wrTrim, wrCols, reportCols, wr.train, wr.season.2017)
wrPredictions <- make.predictions(wrTrim, wrCols, reportCols, wr.train, wr.season.2018)
head(wrPredictions, n=50)
wrReport<- add.differential(wrPredictions, 25)
dplyr::select(wrReport, Player, DKPt, NextDKG, fit, differential)[order(-wrReport$fit), ]


te.season.2017<- teTrim$Season == 2017
te.season.2018<- teTrim$Season == 2018
te.train<- !(season.2017 | season.2018)
tePredictions <- make.predictions(teTrim, teCols, reportCols, te.train, te.season.2017)
tePredictions <- make.predictions(teTrim, teCols, reportCols, te.train, te.season.2018)
head(tePredictions, n=20)
teReport<- add.differential(tePredictions, 20)
dplyr::select(teReport, Player, DKPt, NextDKG, fit, differential)[order(-teReport$fit), ]


allPred<- rbind(rbReport, wrReport, teReport, qbReport)
dplyr::select(allPred, Player, DKPt, fit, NextDKG, differential)[order(-allPred$differential), ]


# Prediction
add.differential <- function(data, n) {
    newDat <- data
    newDat$fit <- newDat$pred
    avgPrediction <- mean(newDat$fit, na.rm=TRUE)
    newDat$differential <- newDat$fit - avgPrediction
    return(newDat)
}

