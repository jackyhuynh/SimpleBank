##UPDATE TRANSACTION CATEGRORY

UpdateCategoryForTransaction <- function(user_id, categoryId, transactionId,connections){
  
  ##Update user_details
  query <- sprintf("update user_transaction_user_id_%s set category_id_fk = %s where transaction_id = %s where deleted=1", user_id, categoryId, transactionId)
  rs <- dbSendQuery(connection, query)
  value <- dbHasCompleted(rs)
  print(paste("Log: User record updated success:",value ))
  dbClearResult(rs)
  dbDisconnect(connection) 
  return(value)
}
