# Analysis of NFL

# Options
library(Rcmdr)
library(ggplot2)
library(Hmisc)

# Startup
projectDir <- "~/Dev/Github/statman/nfl"
setwd(file.path(projectDir, "code"))
getwd()
load(".RData")
dataDir <- file.path(projectDir, "data")

# Loading
 nfl = read.csv(file.path(dataDir, "games", "betting.csv"), header=TRUE)
describe(nfl)

# Analysis
names(nfl)
mean(nfl$spread)
levels(nfl$over_under_result)
subset(nfl, week==17 & season==2017, select=c(home_fav, favorite, underdog, spread, home_recent_scoring, away_recent_scoring, home_recent_allowed, away_recent_allowed, score_home, score_away, spread_diff))