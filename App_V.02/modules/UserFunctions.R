##ADD NEW USER 

addNewUser <- function(connection, userObject){
  
  query <- sprintf("insert into user_details(name_on_card, address, user_ssn, date_of_birth, login_username, login_password) values('%s', '%s', '%s', '%s', '%s', '%s');", userObject@name, userObject@address, userObject@ssn, userObject@dob, userObject@dob, userObject@username, userObject@password);
  rs = dbSendStatement(connection, query);
  result<-dbHasCompleted(rs)
  print(paste("Log: User record inserted success:",result ));
  
  # Clear all the result
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(result); 
};


## Add New Card to the database
addNewCard <- function(connection, cardObject){
  query <- sprintf("insert into card_details(user_id_fk, credit_card_number, expiration_date, name_of_card) values('%s', '%s', STR_TO_DATE ('%s','%s'), '%s');", 
                   cardObject@userId, cardObject@cardNumber, "%m/%d/%Y", cardObject@cardName)
  
  rs = dbSendStatement(connection, query);
  result<-dbHasCompleted(rs)
  print(paste("Log: Card inserted success:",result ));
  
  # Clear all the result
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(result); 
}


##UPDATE EXISTING USER 
updateUserDetails <- function(connection, userObject){
  
  ##Update user_details
  query <- sprintf("update user_details set name_on_card='%s', address='%s', user_ssn='%s', date_of_birth=STR_TO_DATE('%s','%s'),login_username='%s', login_password='%s' where user_id='%s' and deleted=1", userObject@name, userObject@address, userObject@ssn, userObject@dob, "%m/%d/%Y",userObject@username, userObject@password, userObject@userid);
  rs = dbSendStatement(connection, query);
  print(paste("Log: User record updated success:", dbHasCompleted(rs)));
  return(dbHasCompleted(rs)); 
  
};

# Admin Panel
##DELETE EXISTING USER
deleteUser <- function(connection, userObject){
  
  ##delete from user_details
  query <- sprintf("update user_details set deleted=-1 where user_id=%s;", userObject@userid);
  rs1 = dbSendStatement(connection, query);
  print(paste("Log: User record deleted success:", dbHasCompleted(rs1)));

};

##USER AUTHENTICATION
confrimUserCredentails <- function(userObject, connection){
  query <- sprintf("select * from user_details where login_username= '%s' and login_password= '%s' and deleted=1;", userObject@username, userObject@password);

  rs = dbSendQuery(connection, query);
  data = fetch(rs, n= -1);  
  dbClearResult(rs)
  dbDisconnect(connection)
  if(nrow(data) == 1){
    print(paste("Log: Success found user:", userObject@username));
    return(TRUE)
  } else{
    print(paste("Log : Not found user:", userObject@username));
    return(FALSE)
  }
}

##Admin Panel
##GET ALL USERS LIST
getAllUsers <- function(connection){
  query <- sprintf("select user_id as uid, name_on_card as 'Name', address as 'Address' from user_details where deleted=1;");
  rs = dbSendQuery(connection, query);
  data = fetch(rs, n= -1);
  print(paste("Log: Number of records found : ", nrow(data)));
  return(data);
}


##USER AUTHENTICATION
getUserID <- function(username, password, connection){
  query <- sprintf("select user_id from user_details where login_username= '%s' 
                   and login_password= '%s' and deleted=1;", username, password);
  
  rs = dbSendQuery(connection, query);
  data = fetch(rs, n= -1);  
  dbClearResult(rs)
  dbDisconnect(connection)
  
  if(nrow(data) == 1){
    print(paste("Log: Success found user:", username));
    return(data)
  } else{
    print(paste("Log : Not found user:", username));
    return(0)
  }
}
