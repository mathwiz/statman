library(dplyr)
library(FNN)
library(caret)
library(ISLR)


trimCols<- function(df) {
    return( df[c("Season", "Rk", "Player", "Age", "G", "DKPt", "PaAtt", "PaCmp", "ReTgt", "PaTDPG", "RuTDPG", "ReTDPG", "PaYPG", "RuYPG", "ReYPG", "PaAPG", "RuAPG", "ReRPG", "NextDKG")] )
}

trimRows <- function(df, currentSeason) {
    return(df[df$Season==currentSeason | !is.na(df$NextDKG),])
}


knn.model <- function(frame, modelColumns, trainVec, testVec, k) {
    outcomes <- frame %>% dplyr::select(NextDKG)
    model <-  scale(frame[modelColumns])
    train.out <- outcomes[trainVec, ]
    train <- model[trainVec, ]
    test <- model[testVec, ]
    return(knn.reg(train=train, test=test, y=train.out, k=k))
}

make.predictions <- function(frame, modelCols, reportCols, trainVec, testVec, k) {
    predictFrame <- frame[testVec, reportCols]
    model <- knn.model(frame, modelCols, trainVec, testVec, k)
    predictFrame$pred <- model$pred
    return(predictFrame)
}

add.differential <- function(data, n) {
    len <- nrow(data)
    nth <- len - n + 1
    newDat <- data
    newDat$fit <- data$pred
    replacement <- sort(newDat$fit, partial=nth)[nth]
    newDat$differential <- newDat$fit - replacement
    newDat$replacement <- replacement
    return(newDat)
}

report <- function(frame, modelCols, season, length=20, k) {
    reportCols <- c("Player", "DKPt", "NextDKG")
    testVec <- frame$Season == season
    trainVec <- !testVec
    predictions <- make.predictions(frame, modelCols, reportCols, trainVec, testVec, k=k)
    modelFrame <- add.differential(predictions, length)
    report <- dplyr::select(modelFrame, Player, DKPt, NextDKG, fit, differential, replacement)[order(-modelFrame$fit), ]
    return(report)
}


## add standardized variables
qbCols <- c("Age", "PaCmp", "PaTDPG", "RuTDPG", "PaYPG", "RuYPG", "PaAPG", "RuAPG")
rbCols <- c("Age", "RuTDPG", "RuYPG", "RuAPG", "ReTDPG", "ReYPG", "ReRPG")
wrCols <- c("Age", "ReTDPG", "ReYPG", "ReRPG", "RuYPG", "RuAPG", "RuTDPG")
teCols <- c("Age", "ReTDPG", "ReYPG", "ReRPG")
head(rbTrim[rbCols])
head(wrTrim[wrCols])

## wrangle data for knn
names(qbDat)
qbTrim<- trimRows(trimCols(qbDat), 2018)
rbTrim<- trimRows(trimCols(rbDat), 2018)
wrTrim<- trimRows(trimCols(wrDat), 2018)
teTrim<- trimRows(trimCols(teDat), 2018)



## Models
qbReport <- report(frame=qbTrim, modelCols=qbCols, season=2018, length=20, k=6)
head(qbReport, n=30)

rbReport <- report(frame=rbTrim, modelCols=rbCols, season=2018, length=30, k=6)
head(rbReport, n=40)

wrReport <- report(frame=wrTrim, modelCols=wrCols, season=2018, length=40, k=6)
head(wrReport, n=50)

teReport <- report(frame=teTrim, modelCols=teCols, season=2018, length=20, k=6)
head(teReport, n=30)

allPred<- rbind(rbReport, wrReport, teReport, qbReport)
allReport <- dplyr::select(allPred, Player, DKPt, NextDKG, fit, differential)[order(-allPred$differential), ]
head(allReport, n=150)


