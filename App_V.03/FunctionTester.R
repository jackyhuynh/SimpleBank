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




ggplot(AllTransaction, aes(x = Category, y= Amount, fill = Type), xlab="Category") +
  geom_bar(stat="identity", width=.5, position = "dodge")  +
  ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1))

SpendingByCard <- aggregate(Amount ~ Category + Card ,data = UserTransaction ,FUN = sum)

SpendingByCard$Card<-as.factor(SpendingByCard$Card)

for (var in unique(SpendingByCard$Card)) {
  dev.new()
  print( ggplot(SpendingByCard[SpendingByCard$Card==var,], aes(x=Category, y=Amount, fill=Category)) + 
           geom_bar(stat="identity")+
           ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1))+
           ggtitle (as.character(var))  )
}


ggplot(SpendingByCard, aes(Var1, Var2)) + geom_point() + facet_grid(~ Variety)

# ANALYZE BY CARDS
# Testing purpose only
# This is the final query requirement 
connection<-getConnection()
UserCategory<-aggregate(amount~accounts, UserTransaction, FUN=sum)
getTransactions2(1,connection)

