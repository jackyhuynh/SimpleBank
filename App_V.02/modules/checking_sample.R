# @ Truc

geUsertBankTrans <- function(connection){
  query<- sprintf("select * from user_bank")
  rs = dbSendQuery(connection, query)
  allTransaction <- dbFetch(rs, n=-1)
  
  dbClearResult(rs)
  dbDisconnect(connection)
  
  ##Change format from string to date
  allTransaction$date <-as.Date(allTransaction$date,format = "%m/%d/%Y")
  allTransaction$type <- NULL
  return(allTransaction);
}




# The total balance over time
TotalBalance <-
  aggregate(select(UserData.Tidy,-c(details))['balance'], select(UserData.Tidy,-c(details))['date'], last)