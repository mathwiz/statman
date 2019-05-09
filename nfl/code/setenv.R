# Options
library(dplyr)
library(ggplot2)
library(Hmisc)

# Startup
projectDir <- "~/Dev/Github/statman/nfl"
setwd(file.path(projectDir, "code"))
getwd()
load(".RData")
ls()
dataDir <- file.path(projectDir, "data")

# Loading
nfl = read.csv(file.path(dataDir, "games", "betting.csv"), header=TRUE)
describe(nfl)
names(nfl)

nfl$home_recent_wins_factor <- factor(nfl$home_recent_wins, levels=c(0:5))
describe(nfl$home_recent_wins_factor)

nfl$away_recent_wins_factor <- factor(nfl$away_recent_wins, levels=c(0:5))
describe(nfl$away_recent_wins_factor)

