##9. getCategoryNames/ Get all the category
categoriesList <- getCategoryList(connection)
View(categoriesList)


connection<-getConnection()

UserTransaction<-getTransactionDataWithStoreName(connection,1)

conn <- getConnection()

UserInfo<-getUserInfo(1,conn)

max(UserTransaction$Date)


Type<-c('Income','Expense')
Amount<-c(UserInfo$income*interval(
                 min(UserTransaction$Date),
                 max(UserTransaction$Date)) 
                 %/% months(1),
                 sum(UserTransaction$Amount))

df<-data.frame(Type,
               Amount)

ggplot(df, aes(y=Type, x=Amount, fill=Type)) + 
  geom_bar(stat='identity',position = "stack") +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1))





# ANALYZE BY CARDS
# Testing purpose only
# This is the final query requirement 
connection<-getConnection()
UserCategory<-aggregate(amount~accounts, UserTransaction, FUN=sum)
getTransactions2(1,connection)

