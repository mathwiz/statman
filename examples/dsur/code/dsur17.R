library(corpcor)
library(psych)
library(GPArotation)
library(pastecs)



                                        # Factor Analysis

raqDat<- read.delim(file.path(dataDir, "raq.dat"), header=TRUE)
head(raqDat)
nrow(raqDat)

raqMatrix<- cor(raqDat)
raqMatrix

cortest.bartlett(raqDat)
cortest.bartlett(raqMatrix, n=2571)

det(raqMatrix)


## principal components with all variates
nvars<- length(raqDat)
pc1<- principal(raqMatrix, nfactors=nvars, rotate="none")
pc1
plot(pc1$values, type="b")

## decide on 4 factors
pc2<- principal(raqMatrix, nfactors=4, rotate="none")
pc2


