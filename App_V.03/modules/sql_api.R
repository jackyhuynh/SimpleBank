##Class for Card
setClass("card", slots=list(cardId="numeric", userId="numeric", cardNumber="numeric", 
                            expirationDate="character", cardName="character"))


##Create Classes used 
setClass("user", slots=list(userid="numeric", name="character",  address="character",
                            ssn="numeric", dob="character", username="character", password="character", income="numeric"));

#########################################################
# @USER BANK DATA
#########################################################


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
# Function: Logic automated function to get the user bank data total balance over time
# Component: Logic
# Variable: Global Function
getTotalBalance<- function(UserData.Tidy)
{
  return(aggregate(select(UserData.Tidy,-c(details))['balance'], select(UserData.Tidy,-c(details))['date'], last))
}


##CREATE CONNECTION TO DATABASE

# @ Wrucha
##Only change user, password and host
getConnection <- function(){
  connection = dbConnect(MySQL(), user = 'root', password = 'Myskhongbiet88', dbname = 'credit_card_analysis2',
                         host = 'localhost');
  return(connection);
};


#########################################################
# @METHOD TO MODIFY USER, AND USER ID RETRIVE INFO
#########################################################

# @ Wrucha
##ADD NEW USER
addNewUser <- function(connection, userObject){
  
  query <- sprintf("insert into user_details(name_on_card, address, user_ssn, 
                    date_of_birth, login_username, login_password,income) 
                    values('%s', '%s', '%s', '%s', '%s', '%s', '%s');", 
                    userObject@name, userObject@address, userObject@ssn, userObject@dob, 
                    userObject@username, userObject@password, userObject@income);
  
  rs = dbSendStatement(connection, query);
  result<-dbHasCompleted(rs)
  print(paste("Log: User record inserted success:",result ));
  
  # Clear all the result
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(result); 
};


# @Wrucha
##USER AUTHENTICATION
getUserID <- function(username, password, connection){
  query <- sprintf("select user_id from user_details where login_username= '%s' 
                   and login_password= '%s' and deleted=1;", username, password);
  
  rs <- dbSendQuery(connection, query);
  data <- fetch(rs, n= -1);  
  
  # Clean up the connection
  # Prevent Open Connection and injection
  dbClearResult(rs)
  dbDisconnect(connection) # Clean up the connection
  
  if(nrow(data) == 1){
    print(paste("Log: Success found user:", username));
    return(data)
  } else{
    print(paste("Log : Not found user:", username));
    return(0)
  }
}


# @Wrucha
##CREATE NEW TABLE BASED IN USER ID
createNewUserTransactionTable <- function(username, password){
  connection <- getConnection();
  query <- sprintf("select user_id from user_details where login_username= '%s'
                   and login_password= '%s' and deleted=1;", username, password);
  rs = dbSendQuery(connection, query);
  data = fetch(rs, n= -1);
  if(nrow(data) == 1){
    userId <- head(data, n=1);
    query <- sprintf("create table user_transaction_user_id_%s( transaction_id int not null auto_increment, 
                     card_id_fk int, category_id_fk int, locationid_id_fk int, amount double, 
                     date_of_transaction varchar(20), time_of_transaction time, 
                     transaction_type enum('Credit', 'Debit'), deleted int default 1, 
                     primary key (transaction_id), foreign key (card_id_fk) references card_details(card_id), 
                     foreign key (category_id_fk) references category(category_id), foreign key (locationid_id_fk) 
                     references locations(location_id) )auto_increment=1;", userId);
    
    rs = dbSendStatement(connection, query);
    dbDisconnect(connection);
  } else{
    print(paste("Log : Not found user:", username));
    dbDisconnect(connection);
    return(0)
  }
}


# @Truc
# Logic: Get the User Information from User ID
# Component: Logic
# Variable: Global Function
getUserInfo <- function(userid, connection){
  # Get the location list
  rs <-dbSendQuery(connection,
                   paste0("select * from user_details where deleted=1 and user_id='",userid,"'"))
  
  currentUser <- dbFetch(rs)
  
  # Clean up the connection
  # Prevent Open Connection and injection
  dbClearResult(rs)
  dbDisconnect(connection) 
  
  return (currentUser)
}


# @Truc
# Get all the user cards with user id
# Component: Logic
# Variable: Global Function
getAllUserCards<-function(userid, connection){
  query <- paste0(
    "select * from card_details where deleted=1 and user_id_fk='",userid,"'")
  rs <- dbSendQuery(connection, query)
  cards <- dbFetch(rs, n=-1)
  
  # Clean up the connection
  # Prevent Open Connection and injection
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(cards)
}


# @Truc
## Add New Card to the database
addNewCard <- function(connection, cardObject){
  query <- sprintf("insert into card_details(user_id_fk, credit_card_number, expiration_date, name_of_card) 
                   values('%s', '%s','%s' , '%s');", 
                   cardObject@userId, cardObject@cardNumber, cardObject@expirationDate, cardObject@cardName)
  
  rs = dbSendStatement(connection, query);
  result<-dbHasCompleted(rs)
  print(paste("Log: Card inserted success:",result ));
  
  # Clear all the result
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(result); 
}


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
#
# Name: getTransactionWithType
# Function: This function is used to get the debit or credit transaction
# Component: Logic
# Variable: Global Function
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


# @Wrucha
##GET ALL CATEGORY NAMES 
getCategoryList <- function(connection){
  query <- sprintf("select category_id as cid, category_name as Category from category where deleted=1;");
  rs = dbSendQuery(connection, query);
  categoryList = dbFetch(rs, n=-1);
  
  # Clean up the connection
  # Prevent Open Connection and injection
  dbClearResult(rs)
  dbDisconnect(connection) # Clean up the connection
  print(paste("Log: Number of categories returned: ", nrow(categoryList)));
  return(categoryList);
}


# @Truc
##USER AUTHENTICATION
checkUserIDExist <- function(username, connection){
  query <- sprintf("select user_id from user_details where login_username= '%s' 
                   and deleted=1;", username);
  
  rs <- dbSendQuery(connection, query);
  data <- fetch(rs, n= -1);  
  
  # Clean up the connection
  # Prevent Open Connection and injection
  dbClearResult(rs)
  dbDisconnect(connection) # Clean up the connection
  
  if(nrow(data) == 1){
    print(paste("Log: Username is exist:", username));
    return(TRUE)
  } else{
    print(paste("Log : Username is not exist:", username));
    return(FALSE)
  }
}


##UPDATE TRANSACTION CATEGRORY

UpdateCategoryForTransaction <- function(user_id, categoryId, transactionId,connection){
  
  ##Update user_details
  query <- sprintf("update user_transaction_user_id_%s set category_id_fk = %s where transaction_id = %s and deleted=1",
                   user_id, categoryId, transactionId)
  
  rs <- dbSendQuery(connection, query)
  value <- dbHasCompleted(rs)
  
  print(paste("Log: User record updated success:",value ))
  dbClearResult(rs)
  dbDisconnect(connection) 
  
  return(value)
}

