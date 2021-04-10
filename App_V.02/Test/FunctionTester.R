

connection <- getConnection()
dbDisconnect(connection)


##1. Get data for all the transactions with store name
getTransactionDataWithStoreName(connection)

##9. getCategoryNames/ Get all the category
categoriesList <- getCategoryList(connection)
View(categoriesList)

##2. get USer ID based on username and password
getUserID('inewton', 'pwd123', connection)
