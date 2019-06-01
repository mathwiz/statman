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


knn.model <- function(frame, modelColumns, trainVec, testVec, k=5) {
    outcomes <- frame %>% dplyr::select(NextDKG)
    model <-  scale(frame[modelColumns])
    train.out <- outcomes[trainVec, ]
    train <- model[trainVec, ]
    test <- model[testVec, ]
    return(knn.reg(train=train, test=test, y=train.out, k=k))
}

make.predictions <- function(frame, modelCols, reportCols, trainVec, testVec) {
    predictFrame <- frame[testVec, reportCols]
    model <- knn.model(frame, modelCols, trainVec, testVec)
    predictFrame$pred <- model$pred
    return(predictFrame)
}


add.differential <- function(data, n) {
    newDat <- data
    newDat$fit <- newDat$pred
    avgPrediction <- mean(newDat$fit, na.rm=TRUE)
    newDat$differential <- newDat$fit - avgPrediction
    return(newDat)
}

report <- function(frame, modelCols, season, length=20, k=5) {
    reportCols <- c("Player", "DKPt", "NextDKG")
    testVec <- frame$Season == season
    trainVec <- !testVec
    predictions <- make.predictions(frame, modelCols, reportCols, trainVec, testVec)
    modelFrame <- add.differential(predictions, length)
    report <- dplyr::select(modelFrame, Player, DKPt, NextDKG, fit, differential)[order(-modelFrame$fit), ]
    return(report)
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


## Models
qbReport <- report(frame=qbTrim, modelCols=qbCols, season=2018, length=10, k=10)
qbReport

rbReport <- report(frame=rbTrim, modelCols=rbCols, season=2018, length=20, k=5)
rbReport

wrReport <- report(frame=wrTrim, modelCols=wrCols, season=2018, length=20, k=5)
wrReport

teReport <- report(frame=teTrim, modelCols=teCols, season=2018, length=20, k=5)
teReport

allPred<- rbind(rbReport, wrReport, teReport, qbReport)
allReport <- dplyr::select(allPred, Player, DKPt, NextDKG, fit, differential)[order(-allPred$differential), ]
head(allReport, n=150)


