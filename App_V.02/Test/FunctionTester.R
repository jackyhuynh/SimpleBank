##9. getCategoryNames/ Get all the category
categoriesList <- getCategoryList(connection)
View(categoriesList)


connection<-getConnection()

UserTransaction<-getTransactionDataWithStoreName(connection,1)

debitTrans<-SummaryExpense(UserTransaction,'Debit')
creditTrans<-SummaryExpense(UserTransaction,'Credit')

##SET OF DEBIT
debitTrans <-filter(UserTransaction,as.character(UserTransaction$Type)=="Debit" )
debitTrans <- aggregate(Amount~Category, data=debitTrans, FUN=sum)
SumTransaction <- filter(UserTransaction, as.numeric(debitTrans$Amount/sum(debitTrans$Amount)) > 0.005)

# Calculate the percentage of all Transactions smaller than 1 percent
OtherTransaction <- data.frame("Other Expenses",
                               sum(debitTrans$Amount) - sum(SumTransaction$Amount))

# Rename the value
names(OtherTransaction) <- c('Category','Amount')

# Get the total transaction after summary the transaction less than 1 percent
SumTransaction<- rbind(SumTransaction,OtherTransaction)
SumTransaction[order(-SumTransaction[,2]),]




creditTrans <- aggregate(UserTransaction$Amount~UserTransaction$Category, data=filter(UserTransaction,UserTransaction$Type=='Credit' ), FUN=sum)



sum(debitTrans$Amount)

SumTransaction <- filter(UserTransaction, as.numeric(UserTransaction$Amount/sum(UserTransaction$Amount)) > 0.005)


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

SummaryExpense <-function(dataInput, TraType){
  UserTransaction <-filter(dataInput,dataInput$Type==TraType )
  UserTransaction <- aggregate(Amount~Category,UserTransaction , FUN=sum)
  SumTransaction <- filter(UserTransaction, as.numeric(UserTransaction$Amount/sum(UserTransaction$Amount)) > 0.005)
  
  # Calculate the percentage of all Transactions smaller than 1 percent
  OtherTransaction <- data.frame("Other Expenses",
                                 sum(UserTransaction$Amount) - sum(SumTransaction$Amount))
  
  # Rename the value
  names(OtherTransaction) <- c('Category','Amount')
  
  # Get the total transaction after summary the transaction less than 1 percent
  SumTransaction<- rbind(SumTransaction,OtherTransaction)
  
  # Sort the SumTransaction
  return (SumTransaction[order(-SumTransaction[,2]),])
}