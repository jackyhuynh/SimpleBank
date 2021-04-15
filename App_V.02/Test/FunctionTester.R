connection <- getConnection()
dbDisconnect(connection)

##1. Get data for all the transactions with store name
getTransactionDataWithStoreName(connection)

##9. getCategoryNames/ Get all the category
categoriesList <- getCategoryList(connection)
View(categoriesList)





connection<-getConnection()

UserTransaction<-getTransactionDataWithStoreName(connection,1)







# Testing purpose only
# This is the final query requirement
connection<-getConnection()
UserCategory<-aggregate(amount~accounts, data=UserTransaction, FUN=sum)
getTransactions2(1,connection)

