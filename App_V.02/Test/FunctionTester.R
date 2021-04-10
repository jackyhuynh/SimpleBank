##TESTER 

##confrimUserCredentails User confirmation
obj <- new("user",userid=1, name="Miles Davis", ssn=11234567899,
                       username="davis_miles", password="password123");

###Get the connection from the database
connection <- getConnection();

# Disconect the connection
dbDisconnect(connection)

# Confirm user credential
confrimUserCredentails(obj, connection)

## Disconnect the connection
dbDisconnect(connection);

##1. Get data for all the transactions with store name
transactions <-getTransactionDataWithStoreName(connection);

##9. getCategoryNames/ Get all the category
categoriesList <- getCategoryList(connection);
View(categoriesList);



## Set of method to get the user id
userid='inewton'
passwrd= 'pwd123'

rs <-
  dbSendQuery(
    connection,
    paste0(
      "select user_id from user_details where login_username='",
      userid ,
      "' and login_password = '",
      passwrd,
      "'"
    )
  )

if (!dbHasCompleted(rs))
  chunk <- dbFetch(rs, n = 1)

dbClearResult(rs)
dbDisconnect(connection)

value = chunk[[1]]

rs <-
  dbSendQuery(
    getConnection(),
    paste0(
      "select * from user_transaction_user_id_1"
    )
  )

if (!dbHasCompleted(rs))
  transData <- dbFetch(rs)


# Get the user list
users <- getAllUsers(getConnection())
dbDisconnect(getConnection())
View(users)

# Get the category list
categoriesList <- getCategoryList(getConnection())
dbDisconnect(getConnection())
View(categoriesList)

# Get the card list


# Get the location list
rs <-
  dbSendQuery(
    getConnection(),
    paste0(
      "select * from user_details where user_id='",
      value ,"'"
    )
  )

currentUser <- dbFetch(rs)


connection<-getConnection()


# 
