library(MASS)
library(ggplot2)
library(FNN)


head(Boston)
x.boston <- Boston[c("lstat")]
head(x.boston)
y.boston <- Boston$medv
head(y.boston)
lstat.grid = data.frame(lstat = seq(range(x.boston$lstat)[1], range(x.boston$lstat)[2], by = 0.01))

pred.001 <- knn.reg(train=x.boston, test=lstat.grid, y=y.boston, k=1)
pred.005 <- knn.reg(train=x.boston, test=lstat.grid, y=y.boston, k=5)
pred.010 <- knn.reg(train=x.boston, test=lstat.grid, y=y.boston, k=10)
pred.050 <- knn.reg(train=x.boston, test=lstat.grid, y=y.boston, k=50)
pred.100 <- knn.reg(train=x.boston, test=lstat.grid, y=y.boston, k=100)
pred.200 <- knn.reg(train=x.boston, test=lstat.grid, y=y.boston, k=200)


par(mfrow=c(3,2))

plot(medv ~ lstat, data = Boston, cex = .8, col = "dodgerblue", main = "k = 1")
lines(lstat_grid$lstat, pred.001$pred, col = "darkorange", lwd = 0.25)

plot(medv ~ lstat, data = Boston, cex = .8, col = "dodgerblue", main = "k = 5")
lines(lstat_grid$lstat, pred.005$pred, col = "darkorange", lwd = 0.75)

plot(medv ~ lstat, data = Boston, cex = .8, col = "dodgerblue", main = "k = 10")
lines(lstat_grid$lstat, pred.010$pred, col = "darkorange", lwd = 1)

plot(medv ~ lstat, data = Boston, cex = .8, col = "dodgerblue", main = "k = 25")
lines(lstat_grid$lstat, pred.050$pred, col = "darkorange", lwd = 1.5)

plot(medv ~ lstat, data = Boston, cex = .8, col = "dodgerblue", main = "k = 50")
lines(lstat_grid$lstat, pred.100$pred, col = "darkorange", lwd = 2)

plot(medv ~ lstat, data = Boston, cex = .8, col = "dodgerblue", main = "k = 200")
lines(lstat_grid$lstat, pred.200$pred, col = "darkorange", lwd = 2)

