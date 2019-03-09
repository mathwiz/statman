
album1<- read.delim(file.path(dataDir, "Album Sales 1.dat"), header=TRUE)
albumSalesLM.1<- lm(sales ~ adverts, data=album1, na.action=na.exclude)
summary(albumSalesLM.1)


