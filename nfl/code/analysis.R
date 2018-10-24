# Analysis of NFL

# Startup
setwd("~/Dev/Github/statman/nfl/code")
load(".RData")
library(Hmisc)
describe(nfl)

# Analysis
mean(nfl$spread)