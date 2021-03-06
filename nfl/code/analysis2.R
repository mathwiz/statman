# Analysis of NFL

# Options
library(Rcmdr)
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


# Analysis
describe(nfl$spread_diff)
describe(nfl$over_under_diff)

nfl2017 <- subset(nfl, season==2017,)
nflRecent <- subset(nfl, season>2014,)
pickEmGames <- nfl[nfl$spread==0.0,]
roadFavorites <- nfl[nfl$home_fav=="Away",]

describe(pickEmGames)
describe(roadFavorites)

orderedVsSpread <- nfl[order(nfl$spread_diff),]
head(orderedVsSpread)
tail(orderedVsSpread)

by(nfl$spread_diff, nfl$home_fav, describe)
by(nfl$over_under_diff, nfl$home_fav, describe)

by(nfl$spread_diff, nfl$home_recent_wins_factor, describe)
by(nfl$over_under_diff, nfl$home_recent_wins_factor, describe)

by(nfl$spread_diff, nfl$away_recent_wins_factor, describe)
by(nfl$over_under_diff, nfl$home_recent_wins_factor, describe)


# Plots
graph <- ggplot(nflRecent, aes(home_recent_scoring, score_home, colour=home_fav))
graph + geom_point(position="jitter") + geom_smooth(method="lm", aes(fill=home_fav) alpha=0.3)

spread.histogram <- ggplot(nfl, aes(spread_diff))
spread.histogram + geom_histogram(binwidth=1)
ggsave("Spread_Diff.png")

over_under.histogram <- ggplot(nfl, aes(over_under_diff))
over_under.histogram + geom_histogram(binwidth=1)
ggsave("Over_Under_Diff.png")

pick.histogram <- ggplot(pickEmGames, aes(over_under_diff))
pick.histogram + geom_histogram(binwidth=2)

density <- ggplot(nfl, aes(spread_diff))
density + geom_density()
ggsave("Spread_Diff_Density.png")

boxplot <- ggplot(nfl, aes(home_fav, spread_diff))
boxplot + geom_boxplot() + labs(x = "Favorite", y = "Spread Result")
ggsave("Spread_Diff_Boxplot.png")
