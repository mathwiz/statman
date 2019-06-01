dataDir<- "../data"

qbDat<- read.csv(file.path(dataDir, "qb.csv"), header=TRUE)
head(qbDat)

rbDat<- read.csv(file.path(dataDir, "rb.csv"), header=TRUE)
head(rbDat)

wrDat<- read.csv(file.path(dataDir, "wr.csv"), header=TRUE)
head(wrDat)

teDat<- read.csv(file.path(dataDir, "te.csv"), header=TRUE)
head(teDat)

