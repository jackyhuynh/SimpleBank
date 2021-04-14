


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


# @Truc
# Get the User Info from User ID
getUserInfo <- function(userid, connection){
  # Get the location list
  rs <-dbSendQuery(connection,
                   paste0("select * from user_details where user_id='",userid,"'"))
  
  currentUser <- dbFetch(rs)
  
  # Clean up the connection
  # Prevent Open Connection and injection
  dbClearResult(rs)
  dbDisconnect(connection) 
  
  return (currentUser)
}
