##9. getCategoryNames/ Get all the category
categoriesList <- getCategoryList(connection)
View(categoriesList)


connection<-getConnection()

UserTransaction<-getTransactionDataWithStoreName(connection,1)
conn <- getConnection()
UserInfo<-getUserInfo(1,conn)
UserInfo$income
Expense<-sum(UserTransaction$Amount)


date_1 <-min(UserTransaction$Date)           # Create example dates
date_2 <- max(UserTransaction$Date)

Income<-UserInfo$income*interval(date_1, date_2) %/% months(1)    # Apply interval & months
Chart<-c(Income,Expense)
# 52


# ANALYZE BY CARDS
# Testing purpose only
# This is the final query requirement 
connection<-getConnection()
UserCategory<-aggregate(amount~accounts, UserTransaction, FUN=sum)
getTransactions2(1,connection)

