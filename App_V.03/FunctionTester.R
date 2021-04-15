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
#########################################
connection<-getConnection()
user_id=1

query1<-sprintf("SELECT sum(amount) FROM credit_card_analysis2.user_transaction_user_id_%s;",user_id)
rs <- dbSendQuery(connection, query1)
Expense<-dbFetch(rs)
dbClearResult(rs)

query2<-sprintf("SELECT date_of_transaction FROM credit_card_analysis2.user_transaction_user_id_%s;",user_id)
rs <- dbSendQuery(connection, query2)
DateBetween<-dbFetch(rs)
dbClearResult(rs)
DateBetween$date_of_transaction <- as.Date(DateBetween$date_of_transaction,format = "%Y-%m-%d")
MonthBetween<- interval(min(DateBetween$date_of_transaction),max(DateBetween$date_of_transaction))%/% months(1)

query3<-sprintf("SELECT income FROM credit_card_analysis2.user_details where user_id=%s;",user_id)
rs <- dbSendQuery(connection, query3)
Income<-dbFetch(rs)
dbClearResult(rs)

Income$income <- Income$income*MonthBetween
df <- cbind(Income,Expense)
df<- c('Total Income','Total Expense')
dbDisconnect(connection)

# ANALYZE BY CARDS
# Testing purpose only
# This is the final query requirement 
connection<-getConnection()
UserCategory<-aggregate(amount~accounts, UserTransaction, FUN=sum)
getTransactions2(1,connection)

