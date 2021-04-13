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

# This is the function that I used for prototype.
getTransactions <- function(user_id, connection){
  user_id=1
  query <- sprintf("select * from user_transaction_sample")
  rs <- dbSendQuery(connection, query)
  allTransaction <- dbFetch(rs, n=-1)
  allTransaction$date <-as.Date(allTransaction$date,format = "%m/%d/%Y")
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(allTransaction)
}


# This is the function that I used for prototype.
getTransactions <- function(user_id, connection){
  user_id=1
  query <- sprintf("select * from user_transaction_sample")
  rs <- dbSendQuery(connection, query)
  allTransaction <- dbFetch(rs, n=-1)
  allTransaction$date <-as.Date(allTransaction$date,format = "%m/%d/%Y")
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(allTransaction)
}


getTransactions2 <- function(user_id, connection){
  user_id=1
  query <- sprintf("select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date',
  t.time_of_transaction as 'Time', t.transaction_type as 'Type', c.category_name as 'Category', cd.name_of_card as 'Card',
  l.location_name as 'Store Name' , l.location_latitude as 'Latitude', l.location_longitude as 'Longitude'
  from user_transaction_user_id_1 as t
  inner join locations as l on (t.locationid_id_fk = l.location_id)
  inner join category as c  on (c.category_id = t.category_id_fk)
  inner join card_details as cd on (cd.card_id = t.card_id_fk)
  where l.deleted=1 and t.deleted=1  and c.deleted=1 and cd.deleted=1
  order by t.transaction_id;")
  
  rs <- dbSendQuery(connection, query)
  allTransaction <- dbFetch(rs, n=-1)
  allTransaction$date <-as.Date(allTransaction$date,format = "%m/%d/%Y")
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(allTransaction)
}



##8. GET AGGRGATED EXPENDITURE IN CATEGORY FOR CURRENT MONTH

getAggregatedExpenditureByCategory <- function(connection){
  
  query <- sprintf("select sum(t.amount) as 'Sum', c.category_name as Category from user_transaction_user_id_1 as t left join category as c on t.category_id_fk = c.category_id where month(t.date_of_transaction) = month(sysdate()) and t.deleted=1 and c.deleted=1 group by c.category_name; ");
  rs = dbSendQuery(connection, query);
  aggregateTransactionDetails = dbFetch(rs, n=-1);
  print(paste("Log: Number of categories: ", nrow(aggregateTransactionDetails)));
  return(aggregateTransactionDetails);
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

getAllUserCards<-function(userid, connection){
  query <- paste0(
    "select * from card_details where user_id_fk='",
    userid,
    "'"
  )
  rs <- dbSendQuery(connection, query)
  cards <- dbFetch(rs, n=-1)
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(cards)
}