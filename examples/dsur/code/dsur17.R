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

factor.model(pc2$loadings)
factor.residuals(raqMatrix, pc2$loadings)

## analyze residuals
residuals<- factor.residuals(raqMatrix, pc2$loadings)
residuals<- as.matrix(residuals[upper.tri(residuals)])
large.resid<- abs(residuals) > 0.05
sum(large.resid) / nrow(residuals)
sqrt(mean(residuals^2))
hist(residuals)


                                        # Rotation

pc3<- principal(raqMatrix, nfactors=4, rotate="varimax")
print.psych(pc3, cut=0.3, sort=TRUE)

pc4<- principal(raqMatrix, nfactors=4, rotate="oblimin")
print.psych(pc4, cut=0.3, sort=TRUE)
## structure matrix
pc4$loadings %*% pc4$Phi


