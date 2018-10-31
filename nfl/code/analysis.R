# Analysis of NFL

# Options
library(Rcmdr)
library(dplyr)
library(ggplot2)
library(Hmisc)
library(polycor)

# Startup
projectDir <- "~/Dev/Github/statman/nfl"
setwd(file.path(projectDir, "code"))
getwd()
load(".RData")
ls()
dataDir <- file.path(projectDir, "data")

# Loading and Varialbes
nfl = read.csv(file.path(dataDir, "games", "betting.csv"), header=TRUE)
describe(nfl)
names(nfl)

nfl$home_recent_wins_factor <- factor(nfl$home_recent_wins, levels=c(0:5))
describe(nfl$home_recent_wins_factor)

nfl$away_recent_wins_factor <- factor(nfl$away_recent_wins, levels=c(0:5))
describe(nfl$away_recent_wins_factor)

nfl$over_under_pred <- (nfl$home_recent_scoring + nfl$away_recent_allowed)/2 + (nfl$away_recent_scoring + nfl$home_recent_allowed)/2

nfl$over_under_diff_pred <- nfl$over_under_pred - nfl$over_under_line
summary(nfl$over_under_diff_pred)


nfl2017 <- subset(nfl, season==2017,)
nflRecent <- subset(nfl, season>2014,)
pickEmGames <- nfl[nfl$spread==0.0,]
spreadGames <- nfl[nfl$spread!=0.0,]
roadFavorites <- nfl[nfl$home_fav=="Away",]
predictorGames <- nfl[nfl$week>5,]
largeOverUnderPredDiff <- predictorGames[abs(predictorGames$over_under_diff_pred) > 0.5,]
underPredDiff <- predictorGames[predictorGames$over_under_diff_pred < (-4),]
overPredDiff <- predictorGames[predictorGames$over_under_diff_pred > 4,]


# Descriptive Analysis
describe(nfl$spread_diff)
describe(nfl$over_under_diff)
summary(nfl$over_under_line)
summary(nfl$over_under_total)

describe(pickEmGames)
describe(roadFavorites)
describe(largeOverUnderPredDiff)
largeOverUnderPredDiff[1:29, c("season", "week", "over_under_line", "over_under_pred","over_under_diff_pred", "over_under_result")]
describe(largeOverUnderPredDiff$over_under_result)

shapiro.test(roadFavorites$spread_diff)
shapiro.test(pickEmGames$over_under_diff)
shapiro.test(nflRecent$over_under_diff)

orderedVsSpread <- nfl[order(nfl$spread_diff),]
head(orderedVsSpread)
tail(orderedVsSpread)

by(nfl$spread_diff, nfl$home_fav, describe)
by(nfl$over_under_diff, nfl$home_fav, describe)

by(nfl$spread_diff, nfl$home_recent_wins_factor, describe)
by(nfl$over_under_diff, nfl$home_recent_wins_factor, describe)

by(nfl$spread_diff, nfl$away_recent_wins_factor, describe)
by(nfl$over_under_diff, nfl$home_recent_wins_factor, describe)

describe(predictorGames$over_under_diff_pred)

# Plots
graph <- ggplot(nflRecent, aes(home_recent_scoring, score_home, colour=home_fav))
graph + geom_point(position="jitter") + geom_smooth(method="lm", aes(fill=home_fav), alpha=0.3)

graph <- ggplot(spreadGames, aes(spread_diff, spread))
graph + geom_point(position="jitter") + geom_smooth(method="lm", alpha=0.3)

spread.histogram <- ggplot(nfl, aes(spread_diff))
spread.histogram + geom_histogram(aes(y=..density..), binwidth=1, colour="Black", fill="White") + stat_function(fun=dnorm, args=list(mean=mean(nfl$spread_diff, na.rm=TRUE), sd=sd(nfl$spread_diff, na.rm=TRUE)),colour="Blue", size=1)
ggsave("Spread_Diff.png")

over_under.histogram <- ggplot(nfl, aes(over_under_diff))
over_under.histogram + geom_histogram(aes(y=..density..), binwidth=1, colour="Black", fill="White") + stat_function(fun=dnorm, args=list(mean=mean(nfl$over_under_diff, na.rm=TRUE), sd=sd(nfl$over_under_diff, na.rm=TRUE)),colour="Blue", size=1)
ggsave("Over_Under_Diff.png")

over_under_total.histogram <- ggplot(predictorGames, aes(over_under_total))
over_under_total.histogram + geom_histogram(aes(y=..density..), binwidth=1, colour="Black", fill="White") + stat_function(fun=dnorm, args=list(mean=mean(nfl$over_under_total, na.rm=TRUE), sd=sd(nfl$over_under_total, na.rm=TRUE)),colour="Blue", size=1)

pick.histogram <- ggplot(pickEmGames, aes(over_under_diff))
pick.histogram + geom_histogram(binwidth=2)

density <- ggplot(nfl, aes(spread_diff))
density + geom_density()
ggsave("Spread_Diff_Density.png")

boxplot <- ggplot(nfl, aes(home_fav, spread_diff))
boxplot + geom_boxplot() + labs(x = "Favorite", y = "Spread Result")
ggsave("Spread_Diff_Boxplot.png")

overUnderLine <- ggplot(predictorGames, aes(over_under_line, over_under_total, colour=over_under_result))
overUnderLine + geom_point(position="jitter") + geom_smooth(method="lm", aes(fill=over_under_result), alpha=0.3)

overUnderPred <- ggplot(predictorGames, aes(over_under_pred, over_under_total, colour=over_under_result))
overUnderPred + geom_point(position="jitter") + geom_smooth(method="lm", aes(fill=over_under_result), alpha=0.3)


# Regression
OverUnderModel <- lm(predictorGames$over_under_total ~ predictorGames$over_under_pred, na.action=na.exclude)
summary(OverUnderModel)
OverUnderLineModel <- lm(predictorGames$over_under_total ~ predictorGames$over_under_line, na.action=na.exclude)
summary(OverUnderModel)
summary(OverUnderLineModel)
plot(predictorGames$over_under_pred, predictorGames$over_under_total)
plot(predictorGames$over_under_line, predictorGames$over_under_total)
hist(predictorGames$over_under_total)


