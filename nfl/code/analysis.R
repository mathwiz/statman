# Analysis of NFL

# Startup
setwd("~/Dev/Github/statman/nfl/code")
load(".RData")
library(Rcmdr)
library(ggplot2)
library(Hmisc)
describe(nfl)

# Loading
 nfl = read.csv("/Users/yohanlee/Dev/Github/statman/nfl/data/games/betting.csv", header=TRUE)

# Analysis
names(nfl)
mean(nfl$spread)