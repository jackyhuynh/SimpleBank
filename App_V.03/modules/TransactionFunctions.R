##CREATE CONNECTION TO DATABASE

# @ Wrucha
##Only change user, password and host
getConnection <- function(){
  connection = dbConnect(MySQL(), user = 'root', password = 'Myskhongbiet88', dbname = 'credit_card_analysis2',
                         host = 'localhost');
  return(connection);
};


# @ Wrucha
## 1. GET ALL TRANSACTION DATA
getTransactionDataWithStoreName <- function(connection, userId){
  
  query <- sprintf("select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date',
t.time_of_transaction as 'Time', t.transaction_type as 'Type', c.category_name as 'Category', cd.name_of_card as 'Card',
l.location_name as 'Store Name' , l.location_latitude as 'Latitude', l.location_longitude as 'Longitude'
from user_transaction_user_id_%s as t
inner join locations as l on (t.locationid_id_fk = l.location_id)
inner join category as c  on (c.category_id = t.category_id_fk)
inner join card_details as cd on (cd.card_id = t.card_id_fk)
where l.deleted=1 and t.deleted=1  and c.deleted=1 and cd.deleted=1
order by t.transaction_id;", userId)
  rs = dbSendQuery(connection, query)
  transactionDataWithStoreName = dbFetch(rs, n=-1)
  dbClearResult(rs)
  dbDisconnect(connection)
  ##Change format from string to date
  transactionDataWithStoreName$Date <- as.Date(transactionDataWithStoreName$Date,format = "%Y-%m-%d")
  
  #print(paste("Log: Data returned for all transactions: ", nrow(transactionDataWithStoreName)));
  return(transactionDataWithStoreName);
}


# @Truc
# This function is used to get the debit or credit transaction
getTransactionWithType <- function(connection, userId, TransType){
  query <- sprintf("select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date',
 t.transaction_type as 'Type', c.category_name as 'Category' from user_transaction_user_id_%s as t inner join category as c  on (c.category_id = t.category_id_fk)
where t.deleted=1  and c.deleted=1 and t.transaction_type='%s'
order by t.transaction_id;", userId,TransType)
  rs <- dbSendQuery(connection, query)
  transactions <- dbFetch(rs, n=-1)
  dbClearResult(rs)
  dbDisconnect(connection)
  ##Change format from string to date
  transactions$Date <- as.Date(transactions$Date,format = "%Y-%m-%d")
  
  return(transactions);
}






