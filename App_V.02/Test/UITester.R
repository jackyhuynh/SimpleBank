library(shiny)
library(DBI)



ui <- fluidPage(
  textInput("ID1", "First ID:", "1"),
  DT::dataTableOutput("transtable1"),
  br(),
  DT::dataTableOutput("transtable2")
)

server <- function(input, output, session) {
  id=1
  UserTransaction<-reactive({
    conn <- getConnection()
    getTransactionDataWithStoreName(conn,id)})
  
  output$transtable1 <- DT::renderDataTable({
    
    
    conn <- getConnection()
    
    on.exit(dbDisconnect(conn), add = TRUE)
    sql <-
      sprintf(
        "select t.transaction_id as tid, t.amount as Amount, t.date_of_transaction as 'Date',
t.time_of_transaction as 'Time', t.transaction_type as 'Type', c.category_name as 'Category', cd.name_of_card as 'Card',
l.location_name as 'Store Name' , l.location_latitude as 'Latitude', l.location_longitude as 'Longitude'
from user_transaction_user_id_%s as t
inner join locations as l on (t.locationid_id_fk = l.location_id)
inner join category as c  on (c.category_id = t.category_id_fk)
inner join card_details as cd on (cd.card_id = t.card_id_fk)
where l.deleted=1 and t.deleted=1  and c.deleted=1 and cd.deleted=1
order by t.transaction_id;",
        input$ID1
      )
    query <- sqlInterpolate(conn, sql)
    dbGetQuery(conn, query)
  })
  
  output$transtable2 <- DT::renderDataTable({
    df<-UserTransaction()
    df
  })
}

shinyApp(ui, server)