##9. getCategoryNames/ Get all the category
categoriesList <- getCategoryList(connection)
View(categoriesList)


connection<-getConnection()
df<-getIncomeAndExpense(connection,1)

ggplot(df, aes(y=Type, x=Amount, fill=Type)) + 
  geom_bar(stat='identity',position = "stack") +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1))
#########################################

connection<-getConnection()
UserTransaction<-getTransactionDataWithStoreName(connection,1)

UserCards <- aggregate(Amount~Card,data=UserTransaction, FUN=sum)


ggplot(UserCards, aes(y=Card, x=Amount, fill=Card)) + 
  geom_bar(stat='identity',position = "stack") +
  theme_bw() +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1),
                 panel.border = element_blank(), panel.grid.major = element_blank(),
                 panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) 



# ANALYZE BY CARDS
# Testing purpose only
# This is the final query requirement 
connection<-getConnection()
UserCategory<-aggregate(amount~accounts, UserTransaction, FUN=sum)
getTransactions2(1,connection)

