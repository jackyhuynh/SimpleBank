
##GET ALL CATEGORY NAMES 
getCategoryList <- function(connection){
  query <- sprintf("select category_id as cid, category_name as Category from category where deleted=1;");
  rs = dbSendQuery(connection, query);
  categoryList = dbFetch(rs, n=-1);
  print(paste("Log: Number of categories returned: ", nrow(categoryList)));
  return(categoryList);
}


##ADD NEW CATEGORIES 

addNewCategory <- function(connection, categoryObj){
  
  query <- sprintf("insert into category(category_name) values('%s')", categoryObj@categoryName);
  rs = dbSendStatement(connection, query);
  print(paste("Log: Category record inserted success:", dbHasCompleted(rs)));
  return(dbHasCompleted(rs));
}

##DELETE A CATEGORY BY SELECTED ID

deleteCategory <- function(connection, categoryObj){
  
  ##First delete form user_details table 
  query <- sprintf("update category set deleted=-1 where category_id=%s;", categoryObj@categoryId);
  rs = dbSendStatement(connection, query);
  print(paste("Log: Deleted record from category table:", dbHasCompleted(rs)));
}
