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


##3. GET TRANSACTION DETAILS BETWEEN TIME PERIOD

getTransactionBetweenTimePeriod <- function(connection, startDate, endDate){
  
  startDate <- format(as.Date(startDate, "%m/%d/%Y"), "%Y-%m-%d"); 
  endDate <- format(as.Date(endDate, "%m/%d/%Y"), "%Y-%m-%d"); 
  
  query <- sprintf("select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date', t.time_of_transaction as 'Time', t.transaction_type as 'Type', l.location_name as 'Store Name' from user_transaction_user_id_1 as t left join locations as l on l.location_id = t.locationid_id_fk where t.date_of_transaction between '%s' and '%s' and t.deleted=1 and l.deleted=1 order by t.transaction_id;", startDate, endDate);
  rs = dbSendQuery(connection, query);
  transactionsBetweenDates = dbFetch(rs, n=-1);
  transactionsBetweenDates$Date <-format(as.Date(transactionsBetweenDates$Date, "%Y-%m-%d"), "%m/%d/%y");
  print(paste("Log:Data returned between dates: ", nrow(transactionsBetweenDates)));
  return(transactionsBetweenDates);
}

##4. GET TRANSACTIONS COORDINATES BETWEEN DATES TO PLOT ON MAP

getTransactionCoordinatesForTimePeriod <- function(connection, startDate, endDate){
  
  startDate <- format(as.Date(startDate, "%m/%d/%Y"), "%Y-%m-%d"); 
  endDate <- format(as.Date(endDate, "%m/%d/%Y"), "%Y-%m-%d"); 
  query <- sprintf("select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date', t.time_of_transaction as 'Time', l.location_name as 'LocationName', l.location_latitude as Latitude, l.location_longitude as Longitude, l.location_address as Address from user_transaction_user_id_1 as t join locations as l on t.locationid_id_fk = l.location_id where date_of_transaction between '%s' and '%s' and t.deleted=1 and l.deleted=1;", startDate, endDate);
  rs = dbSendQuery(connection, query);
  transactionsBetweenDates = dbFetch(rs, n=-1);
  transactionsBetweenDates$Date <-format(as.Date(transactionsBetweenDates$Date, "%Y-%m-%d"), "%m/%d/%y");
  print(paste("Log: Data transactions and locations returned: ", nrow(transactionsBetweenDates)));
  return(transactionsBetweenDates);
}

##5. GET TRANSACTIONS BY CATEGORY

getTransactionsByCategoryForCurrentMonth <- function(connection){
  
  query <- sprintf("select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date', c.category_name as 'Category' from user_transaction_user_id_1 as t left join category as c on t.category_id_fk = c.category_id where month(t.date_of_transaction) = month(sysdate()) and t.deleted=1 and c.deleted=1 order by t.transaction_id;");
  rs = dbSendQuery(connection, query);
  transactionsByCategory = dbFetch(rs, n=-1);
  #transactionsByCategory$Date <-format(as.Date(transactionsByCategory$Date, "%Y-%m-%d"), "%m/%d/%y");
  print(paste("Log: Transactions returned for current month: ", nrow(transactionsByCategory)));
  return(transactionsByCategory);
}

##6. GET TRANSACTIONS BY CARD

getTransactionsByACard <- function(connection, cardObject){
  
  query <- sprintf("select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date', t.time_of_transaction as 'Time', t.transaction_type as 'Type' from user_transaction_user_id_1 as t where t.card_id_fk = %s and t.deleted=1;", cardObject@cardId);
  rs = dbSendQuery(connection, query);
  transactionByCard = dbFetch(rs, n=-1);
  transactionByCard$Date <-format(as.Date(transactionByCard$Date, "%Y-%m-%d"), "%m/%d/%y");
  print(paste("Log: Transactions for the selected card : ", nrow( transactionByCard)));
  return(transactionByCard);
}

##7. GET MONTHLY EXPENDITURE BY CATEGORY NAME

getMonthlyExpenditureByCategoryName <- function(connections){
  
  query <- sprintf("select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date', c.category_name as 'Category' from user_transaction_user_id_1 as t left join category as c on t.category_id_fk = c.category_id where month(t.date_of_transaction) = month(sysdate()) and t.deleted=1 and c.deleted=1 order by t.transaction_id;");
  rs = dbSendQuery(connection, query);
  transactionsByCategory = dbFetch(rs, n=-1);
  transactionsByCategory$Date <-format(as.Date(transactionsByCategory$Date, "%Y-%m-%d"), "%m/%d/%y");
  print(paste("Log: Transactions for the selected month : ", nrow( transactionsByCategory)));
  return(transactionsByCategory);
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