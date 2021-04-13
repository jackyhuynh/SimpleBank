##UPDATE TRANSACTION CATEGRORY

UpdateCategoryForTransaction <- function(transactionObject, categoryObject,connections){
  
  ##Update user_details
  query <- sprintf("update user_transaction_user_id_1 set category_id_fk = %s where transaction_id = %s where deleted=1", categoryObject@categoryId, transactionObject@transactionId);
  rs = dbSendStatement(connection, query);
  print(paste("Log: User record updated success:", dbHasCompleted(rs)));
  return(dbHasCompleted(rs)); 
}
