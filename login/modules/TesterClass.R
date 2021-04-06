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


##2. get transactions for the month
transactions <- getCurrentMonthTransaction(connection)
View(transactions)

##3. getTransactions between time 
transactions <- getTransactionBetweenTimePeriod(connection, "02/01/2021", "03/31/2021");
View(transactions);

##4. getTransactionCoordinatesForTimePeriod 
transactions <- getTransactionCoordinatesForTimePeriod(connection, "02/01/2021", "03/31/2021");
View(transactions);

#5. getTransactionsByCategoryForCurrentMonth
transactions <- getTransactionsByCategoryForCurrentMonth(connection);
View(transactions);

# May not need this function
#6. getTransactionsByACard
cardObj <- new("card",cardId=1, userId=1, cardNumber=12345678, expirationDate="03/31/2021");
transactions <- getTransactionsByACard(connection, cardObj);
View(transactions)

##7. getMonthlyExpenditureByCategoryName
transactions <- getMonthlyExpenditureByCategoryName(connection);
View(transactions);

##8. getAggregatedExpenditureByCategory
transactions <- getAggregatedExpenditureByCategory(connection);
View(transactions)

## Get all the category TRUC
##9. getCategoryNames
categoriesList <- getCategoryList(connection);
View(categoriesList);


##addNewCategory
categoryObject <- new("category", categoryName="Test Category");
addNewCategory(connection, categoryObject);

##deleteCategory
categoryObject <- new("category", categoryId=24);
deleteCategory(connection, categoryObject)


##addNewUser

userObj <- new("user", name="Ameet Newton", ssn=5655656, username="inewton", password="pwd123", dob="01/21/1975", address="Londn, England");
addNewUser(connection, userObj);

##updateUserDetails
userObj <- new("user", userid=15, name="Test Name Update", ssn=11234567899, username="test_user12", password="pwd123", dob="01/21/1991", address="Test address 12345");
updateUserDetails(connection, userObj)


##deleteUser
userObj <- new("user", userid=18);
deleteUser(connection, userObj)

##getAllUsers
users <- getAllUsers(connection);
View(users)