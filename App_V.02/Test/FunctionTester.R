

connection <- getConnection()
dbDisconnect(connection)


##1. Get data for all the transactions with store name
transactions <-getTransactionDataWithStoreName(connection)

##9. getCategoryNames/ Get all the category
categoriesList <- getCategoryList(connection)
View(categoriesList)

