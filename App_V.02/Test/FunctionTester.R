##TESTER 

##confrimUserCredentails User confirmation
obj <- new("user",userid=1, name="Miles Davis", ssn=11234567899,
                       username="davis_miles", password="password123");

###Get the connection from the database
connection <- getConnection();

### Truc: Unable to test this function. Please Check
### Truc: Update: Test good, just need to run the connection first
confrimUserCredentails(obj, connection)

## Disconnect the connection
dbDisconnect(connection);

##1. Get data for all the transactions with store name
transactions <-getTransactionDataWithStoreName(connection);
View(transactions);

## NOT REALLY NEED BECAUSE TRANS SHOW IN LIST 
##2. get transactions for the current month
transactions1 <- getCurrentMonthTransaction(connection)
View(transactions1)

## NOT REALLY NEED BECAUSE TRANS will be extract LATER USING REACTIVE 
##3. getTransactions between time 
transactions2 <- getTransactionBetweenTimePeriod(connection, "02/01/2021", "03/31/2021");
View(transactions2);

##4. getTransactionCoordinatesForTimePeriod 
transactions3 <- getTransactionCoordinatesForTimePeriod(connection, "02/01/2021", "03/31/2021");
View(transactions3);

## NOT REALLY NEED
#5. getTransactionsByCategoryForCurrentMonth
transactions4 <- getTransactionsByCategoryForCurrentMonth(connection);
View(transactions4);

# May not need this function
#6. getTransactionsByACard
cardObj <- new("card",cardId=1, userId=1, cardNumber=12345678, expirationDate="03/31/2021");
transactions <- getTransactionsByACard(connection, cardObj);
View(transactions)

##7. getMonthlyExpenditureByCategoryName
transactions5 <- getMonthlyExpenditureByCategoryName(connection);
View(transactions5);

##8. getAggregatedExpenditureByCategory
transactions <- getAggregatedExpenditureByCategory(connection);
View(transactions)

## Get all the category TRUC
##9. getCategoryNames
categoriesList <- getCategoryList(connection);
View(categoriesList);

##ADMIN ONLY
##addNewCategory
categoryObject <- new("category", categoryName="Test Category");
addNewCategory(connection, categoryObject);

##NEED CAREFUL WITH THIS USER SHOULD NOT BE ABLE TO ADD OR DELETE CATEGORY. 
##ADMIN ONLY
##deleteCategory
categoryObject <- new("category", categoryId=24);
deleteCategory(connection, categoryObject)

##ADMIN ONLY
##ADD NEW USER TO THE DATABASE
##addNewUser
userObj <- new("user", name="Ameet Newton", ssn=5655656, username="inewton", password="pwd123", dob="01/21/1975", address="Londn, England");
addNewUser(connection, userObj);

##ADMIN ONLY
##updateUserDetails
userObj <- new("user", userid=15, name="Test Name Update", ssn=11234567899, username="test_user12", password="pwd123", dob="01/21/1991", address="Test address 12345");
updateUserDetails(connection, userObj)

##ADMIN ONLY
##deleteUser
userObj <- new("user", userid=18);
deleteUser(connection, userObj)

##ADMIN ONLY
##getAllUsers
users <- getAllUsers(connection);
View(users['Name'])


## Set of method to get the user id
userid='inewton'
passwrd= 'pwd123'

rs <-
  dbSendQuery(
    getConnection(),
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
dbDisconnect(connection)

# 
getUserID(username="davis_miles", password="password123",connection)[[1]]

transQuery <-"select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date',
t.time_of_transaction as 'Time', t.transaction_type as 'Type', c.category_name as 'Category',
l.location_name as 'Store Name' , l.location_latitude as 'Latitude', l.location_longitude as 'Longitude'
from user_transaction_user_id_1 as t
inner join locations as l on (t.locationid_id_fk = l.location_id)
inner join category as c  on (c.category_id = t.category_id_fk)
where l.deleted=1 and t.deleted=1  and c.deleted=1
order by t.transaction_id"

rs <-
  dbSendQuery(
    connection,
    paste0(transQuery
    )
  )

AllTraction<-dbFetch(rs)
dbDisconnect(connection)
getMonthlyExpenditureByCategoryName(connection)
AllTraction<-getTransactionDataWithStoreName(connection)
