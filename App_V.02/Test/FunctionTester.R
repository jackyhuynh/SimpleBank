connection <- getConnection()
dbDisconnect(connection)

##1. Get data for all the transactions with store name
getTransactionDataWithStoreName(connection)

##9. getCategoryNames/ Get all the category
categoriesList <- getCategoryList(connection)
View(categoriesList)

##2. get USer ID based on username and password
getUserID('inewton', 'pwd123', connection)



connection<-getConnection()

UserTransaction<-getTransactionDataWithStoreName(connection,1)

head(UserTransaction)

UserTransaction[, c("Type","Date", "Time", "Category","Card","Store Name","Amount")]


str(UserTransaction$Date)

UserTransaction$Date
min(UserTransaction$Date)

# Testing purpose only
# This is the final query requirement
connection<-getConnection()
UserCategory<-aggregate(amount~accounts, data=UserTransaction, FUN=sum)
getTransactions2(1,connection)

