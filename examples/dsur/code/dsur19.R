library(gmodels)
library(MASS)


                                        # Hierarchical regression

surgeryDat<- read.delim(file.path(dataDir, "Cosmetic Surgery.dat"), header=TRUE)
str(surgeryDat)



