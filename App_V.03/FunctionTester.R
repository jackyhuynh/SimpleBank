##9. getCategoryNames/ Get all the category
categoriesList <- getCategoryList(connection)
View(categoriesList)


connection<-getConnection()

UserTransaction<-getTransactionDataWithStoreName(connection,1)

connection<-getConnection()
debitTrans<-getTransactionWithType(connection,1,"Debit")

connection<-getConnection()
creditTrans<-getTransactionWithType(connection,1,"Credit")







##SET OF DEBIT
debitTrans <- filter(UserTransaction,'Type'=="Debit")

AllTransaction <- aggregate(Amount~Category+Type, data=UserTransaction, FUN=sum)

AllTransaction$Type <- as.character(AllTransaction$Type)

debitTrans <- filter(AllTransaction,AllTransaction$Type=="Debit")


date_1 <-min(UserTransaction$Date)           # Create example dates
date_2 <- max(UserTransaction$Date)
install.packages("lubridate")             # Install lubridate package
library("lubridate")                      # Load lubridate package
interval(date_1, date_2) %/% months(1)    # Apply interval & months
# 52


# ANALYZE BY CARDS
# Testing purpose only
# This is the final query requirement 
connection<-getConnection()
UserCategory<-aggregate(amount~accounts, UserTransaction, FUN=sum)
getTransactions2(1,connection)

