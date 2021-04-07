
SummaryExpense <-function(dataInput, TraType){
  UserTransaction <- aggregate(amount~category, data=filter(dataInput,dataInput$type==TraType ), FUN=sum)
  SumTransaction <- filter(UserTransaction, as.numeric(UserTransaction$amount/sum(UserTransaction$amount)) > 0.005)
  
  # Calculate the percentage of all Transactions smaller than 1 percent
  OtherTransaction <- data.frame("Other Expenses",
                                 sum(UserTransaction$amount) - sum(SumTransaction$amount))
  
  # Rename the value
  names(OtherTransaction) <- c('category','amount')
  
  # Get the total transaction after summary the transaction less than 1 percent
  SumTransaction<- rbind(SumTransaction,OtherTransaction)
  
  # Sort the SumTransaction
  return (SumTransaction[order(-SumTransaction[,2]),])
}


customPieChart <- function(inputData){
  par(mar = c(1,1,1,1))
  pie(
    inputData$amount, edges = 200, radius = 0.8,clockwise = TRUE,
    # IMPORTANT
    angle = 45, col = viridis::viridis_pal(option = "magma", direction = -1)(length(inputData$amount)),
    labels = head(scales::percent(as.numeric(inputData$amount/sum(inputData$amount))),-3),
    # NEVER DISPLAY OVERLAPPING LABELS
    cex = 0.7, border = "white",
  )
  legend(
    1,.5,inputData$category,
    cex = 0.7,
    fill = viridis::viridis_pal(option = "magma", direction = -1)(length(inputData$amount))
  )
}

