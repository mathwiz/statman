
album1<- read.delim(file.path(dataDir, "Album Sales 1.dat"), header=TRUE)
albumSalesLM.1<- lm(sales ~ adverts, data=album1, na.action=na.exclude)
summary(albumSalesLM.1)

album2<- read.delim(file.path(dataDir, "Album Sales 2.dat"), header=TRUE)
albumSalesLM.2<- lm(sales ~ adverts, data=album2, na.action=na.exclude)
summary(albumSalesLM.2)

albumSalesLM.3<- lm(sales ~ adverts + airplay + attract, data=album2, na.action=na.exclude)
summary(albumSalesLM.3)
