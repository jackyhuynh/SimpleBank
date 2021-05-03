

##Create Classes used 

##Class for Category
setClass("category", slots=list(categoryId="numeric", categoryName="character"));



##Class for location
setClass("location", slots=list(locationId="numeric", name="character",
                                latitude="character", longitude="character",
                                address="character"));

##Class for transaction
setClass("transactions", slots=list(transactionId="numeric", categoryId="numeric", locationId="numeric", 
                                    transactionDate="character", transactionTime="character", 
                                    transactionType="character", cardId="numeric"));

##Class for Card
setClass("card", slots=list(cardId="numeric", userId="numeric", cardNumber="numeric", expirationDate="character", cardName="character"))


##Create Classes used 
setClass("user", slots=list(userid="numeric", name="character",  address="character",
                            ssn="numeric", dob="character", username="character", password="character", income="numeric"))
