# Album Sales data

album1<- read.delim(file.path(dataDir, "Album Sales 1.dat"), header=TRUE)
albumSalesLM.1<- lm(sales ~ adverts, data=album1, na.action=na.exclude)
summary(albumSalesLM.1)

album2<- read.delim(file.path(dataDir, "Album Sales 2.dat"), header=TRUE)
albumSalesLM.2<- lm(sales ~ adverts, data=album2, na.action=na.exclude)
summary(albumSalesLM.2)

albumSalesLM.3<- lm(sales ~ adverts + airplay + attract, data=album2, na.action=na.exclude)
summary(albumSalesLM.3)

lm.beta(albumSalesLM.3)
confint(albumSalesLM.3)

anova(albumSalesLM.2, albumSalesLM.3)

album2$residuals<- resid(albumSalesLM.3)
album2$std.residuals<- rstandard(albumSalesLM.3)
album2$stu.residuals<- rstudent(albumSalesLM.3)
album2$cooks.distance<- cooks.distance(albumSalesLM.3)
album2$dfbeta<- dfbeta(albumSalesLM.3)
album2$dffit<- dffits(albumSalesLM.3)
album2$leverage<- hatvalues(albumSalesLM.3)
album2$cov.ratios<- covratio(albumSalesLM.3)

album2$large.residuals<- album2$std.residuals > 2 | album2$std.residuals < -2
sum(album2$large.residuals)
album2[album2$large.residuals, c("sales", "airplay", "attract", "adverts", "std.residuals")]
album2[album2$large.residuals, c("cooks.distance", "leverage", "cov.ratios")]

durbinWatsonTest(albumSalesLM.3)
vif(albumSalesLM.3)
1/vif(albumSalesLM.3)
mean(vif(albumSalesLM.3))

hist(album2$stu.residuals)


# Glastonbury Festival data

gfr<- read.delim(file.path(dataDir, "GlastonburyFestivalRegression.dat"), header=TRUE)
summary(gfr)

crusty_v_nma<- c(1,0,0,0)
indie_v_nma<- c(0,1,0,0)
metal_v_nma<- c(0,0,1,0)
contrasts(gfr$music)<- cbind(crusty_v_nma, indie_v_nma, metal_v_nma)
gfr$music

glastonburyModel<- lm(change ~ music, data=gfr)
summary(glastonburyModel)

round(tapply(gfr$change, gfr$music, mean, na.rm=TRUE), 3)

