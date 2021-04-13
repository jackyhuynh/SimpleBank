# @ Truc
#
# Name: geUsertBankTrans
# Function: Logic automated function to get the user bank data 
# Component: Logic
# Variable: Global
geUsertBankTrans <- function(connection){
  query<- sprintf("select * from user_bank")
  rs = dbSendQuery(connection, query)
  allTransaction <- dbFetch(rs, n=-1)
  
  # Clear all the result
  dbClearResult(rs)
  dbDisconnect(connection)
  
  ##Change format from string to date
  allTransaction$date <-as.Date(allTransaction$date,format = "%m/%d/%Y")
  allTransaction$type <- NULL
  return(allTransaction);
}


# @ Truc
#
# Name: getTotalBalance
# Function: Logic automated function to get the user bank data 
# Component: Logic
# Variable: Global
# The total balance over time
getTotalBalance<- function(UserData.Tidy)
{
  return(aggregate(select(UserData.Tidy,-c(details))['balance'], select(UserData.Tidy,-c(details))['date'], last))
}
