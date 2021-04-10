##CREATE CONNECTION TO DATABASE

##Only change user, password and host
getConnection <- function(){
  connection = dbConnect(MySQL(), user = 'root', password = 'Myskhongbiet88', dbname = 'credit_card_analysis2',
                         host = 'localhost');
  return(connection);
};

## 1. GET ALL TRANSACTION DATA
getTransactionDataWithStoreName <- function(connection){
  
  query <- sprintf("select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date',
  t.time_of_transaction as 'Time', t.transaction_type as 'Type', c.category_name as 'Category',
  l.location_name as 'Store Name' , l.location_latitude as 'Latitude', l.location_longitude as 'Longitude'
  from user_transaction_user_id_1 as t
  inner join locations as l on (t.locationid_id_fk = l.location_id)
  inner join category as c  on (c.category_id = t.category_id_fk)
  where l.deleted=1 and t.deleted=1  and c.deleted=1
  order by t.transaction_id")  
  rs = dbSendQuery(connection, query)
  transactionDataWithStoreName = dbFetch(rs, n=-1)
  dbClearResult(rs)
  dbDisconnect(connection)
  
  ##Change format from string to date
  transactionDataWithStoreName$Date <-format(as.Date(transactionDataWithStoreName$Date, "%Y-%m-%d"), "%m/%d/%y");
  #print(paste("Log: Data returned for all transactions: ", nrow(transactionDataWithStoreName)));
  return(transactionDataWithStoreName);
}

getTransactions <- function(user_id, connection){
  user_id=1
  query <- sprintf("select * from user_transaction_sample")
  rs <- dbSendQuery(connection, query)
  allTransaction <- dbFetch(rs, n=-1)
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(allTransaction)
}

# @Truc
# Get all the locations in FW
getFortWayneLocations <- function(connection){
  query <- sprintf("select * from locations_fortwayne_in")
  rs <- dbSendQuery(connection, query)
  FWlocations <- dbFetch(rs, n=-1)
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(FWlocations)
}