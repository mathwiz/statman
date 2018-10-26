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

# Analysis
mean(nfl$spread)

mean(nfl$over_under_line)

levels(nfl$over_under_result)

noOverUnder <- subset(nfl, over_under_result == "", select=c(season, week, home_team, away_team, score_home, score_away, over_under_line, over_under_diff, over_under_result))

nrow(noOverUnder)

nfl2017 <- subset(nfl, season==2017,)
nflRecent <- subset(nfl, season>2014,)
orderedVsSpread <- nfl[order(nfl$spread_diff),]
head(orderedVsSpread)
tail(orderedVsSpread)


# Plots
graph <- ggplot(nflRecent, aes(home_recent_scoring, score_home, colour=home_fav))
graph + geom_point(position="jitter") + geom_smooth(method="lm", aes(fill=home_fav) alpha=0.3)

histogram <- ggplot(nfl, aes(spread_diff))
histogram + geom_histogram(binwidth=1)
ggsave("Spread_Diff.png")

density <- ggplot(nfl, aes(spread_diff))
density + geom_density()
ggsave("Spread_Diff_Density.png")

boxplot <- ggplot(nfl, aes(home_fav, spread_diff))
boxplot + geom_boxplot() + labs(x = "Favorite", y = "Spread Result")
ggsave("Spread_Diff_Boxplot.png")
