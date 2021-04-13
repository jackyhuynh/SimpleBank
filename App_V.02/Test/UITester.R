library(shiny)

connection<-getConnection()

UserTransaction<-getTransactions(1,connection)

connection<-getConnection()

FWlocation <- getFortWayneLocations(connection)

connection<-getConnection()

getAllUserCards(2,connection)

# Testing purpose only

connection<-getConnection()

UserCategory<-aggregate(amount~accounts, data=UserTransaction, FUN=sum)

getTransactions2(1,connection)

getTransactionDataWithStoreName(connection)


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

ui<-fluidPage(
  sidebarLayout(
    sidebarPanel(
      # Monitor and control the action of all Transactions Panel
      conditionalPanel(
        'input.dataset === "All Transaction"',
        checkboxGroupInput(
          "show_trans2",
          "Selections:",
          names(UserTransaction[, c("date", "description", "amount", "type", "category", "accounts")]),
          selected = names(UserTransaction[, c("date", "description", "amount", "type", "category", "accounts")])
        )
      ),
      conditionalPanel(
        'input.dataset === "Expense vs. Income"',
        tags$h3("Total Income vs. Expense Over Time", class = "text-info"),
        # Select date range to be plotted
        tags$p("Note: Choose date to see the total balance between a specific time!"),
        dateRangeInput(
          "DebitDate", strong("Date range"),
          start = min(UserTransaction$date),
          end = max(UserTransaction$date),
          min = min(UserTransaction$date),
          max = max(UserTransaction$date)
        ))
      
    ),
    mainPanel(
      tabsetPanel(
      id = 'dataset',
      #All Transaction
      tabPanel(
        "All Transaction",
        DT::dataTableOutput("transTable"),
        
        printWhiteSpace(),
        tags$em(tags$h3("Deep Analyzing", class = "text-primary")),
        
        tags$div(
          # Select date range to be plotted
          dateRangeInput(
            "dateTransMap",
            strong("Date range"),
            start = min(UserTransaction$date),
            end = max(UserTransaction$date),
            min = min(UserTransaction$date),
            max = max(UserTransaction$date)
          ),
          
        ),
        br(),
        tabsetPanel(
          tabPanel("Map Expense",leafletOutput("map")),
          tabPanel("Analyze By Accounts",
                   sidebarLayout(
                     sidebarPanel(
                       dateRangeInput(
                         "dateAccount",
                         strong("Date range"),
                         start = min(UserTransaction$date),
                         end = max(UserTransaction$date),
                         min = min(UserTransaction$date),
                         max = max(UserTransaction$date)
                       ),
                     ),
                     mainPanel(
                       
                     )
                   ))
        ) # End tabset Panel
      ),
      tabPanel("Expense vs. Income",
               plotOutput("piePlotDebit"),
               sidebarLayout(
                 sidebarPanel (
                   div(
                     tags$h4("Goal Analyst"),
                     tags$p("Will add the goal analyst portion here!")
                   )
                 ),
                 mainPanel(
                   plotOutput("Total")  
                 )
               )
      )
    )
  ))
)

server<-function(input,output, session){
  output$transTable <- DT::renderDataTable({
    DT::datatable(UserTransaction[, input$show_trans2, drop = FALSE])
  })
  
  # Set of methods for the Summary map
  
  TransactionByCard <- reactive({
    req(input$dateTransMap)
    validate(need(!is.na(input$dateTransMap[1]) &!is.na(input$dateTransMap[2]),
      "Error: Please provide both a start and an end date."))
    validate(need(input$dateTransMap[1] < input$dateTransMap[2],
        "Error: Start date should be earlier than end date."))
    TotalBalance %>% filter(date > (input$dateTransMap[1]) &date < (input$dateTransMap[2]))
  })
  
  location <-
    aggregate(amount ~ lat + long,data = UserTransaction,FUN = sum)
  
  location <- merge(location, FWlocation)

  output$map <- renderLeaflet({
    leaflet(data = location) %>% addTiles() %>%
      addMarkers( ~ long, ~ lat, label =  ~ as.character(store), popup = ~ as.character(paste('$',amount)))
  })
  
  # Validate the date before plot
  debitTrans <- reactive({
    req(input$DebitDate)
    validate(need(!is.na(input$DebitDate[1]) & !is.na(input$DebitDate[2]),"Error: Please provide both a start and an end date."))
    validate(need(input$DebitDate[1] < input$DebitDate[2],"Error: Start date should be earlier than end date."))
    debitTrans<-SummaryExpense(UserTransaction %>% filter(date > (input$DebitDate[1]) & date < (input$DebitDate[2])),'debit')
    creditTrans<-SummaryExpense(UserTransaction %>% filter(date > (input$DebitDate[1]) & date < (input$DebitDate[2])),'credit')
    old.par <- par(mfrow=c(1, 2))
    
    pie(
      debitTrans$amount, edges = 200, radius = 0.9,clockwise = TRUE,
      # IMPORTANT
      angle = 45, col = viridis::viridis_pal(option = "magma", direction = -1)(length(debitTrans$amount)),
      labels = head(scales::percent(as.numeric(debitTrans$amount/sum(debitTrans$amount))),-3),
      # NEVER DISPLAY OVERLAPPING LABELS
      cex = 0.7, border = "white",main="Debit Transactions"
    )
    legend(
      1,.3,debitTrans$category,
      cex = 0.7,
      fill = viridis::viridis_pal(option = "magma", direction = -1)(length(debitTrans$amount))
    )
    
    # Credit Transaction
    pie(
      creditTrans$amount, edges = 200, radius = 0.9,clockwise = TRUE,
      # IMPORTANT
      angle = 45, col = viridis::viridis_pal(option = "magma", direction = -1)(length(creditTrans$amount)),
      labels = head(scales::percent(as.numeric(creditTrans$amount/sum(creditTrans$amount))),-3),
      # NEVER DISPLAY OVERLAPPING LABELS
      cex = 0.7, border = "white", main="Credit Transactions"
    )
    legend(
      1,.3,creditTrans$category,
      cex = 0.7,
      fill = viridis::viridis_pal(option = "magma", direction = -1)(length(creditTrans$amount))
    )
    par(old.par)
  })
  
  
  # Plot the total balance
  output$piePlotDebit <- renderPlot({
    debitTrans()
  })
  
  
  totalTrans <- reactive({
    validate(need(!is.na(input$DebitDate[1]) & !is.na(input$DebitDate[2]),"Error: Please provide both a start and an end date."))
    validate(need(input$DebitDate[1] < input$DebitDate[2],"Error: Start date should be earlier than end date."))
    debitTrans<-SummaryExpense(UserTransaction %>% filter(date > (input$DebitDate[1]) & date < (input$DebitDate[2])),'debit')
    creditTrans<-SummaryExpense(UserTransaction %>% filter(date > (input$DebitDate[1]) & date < (input$DebitDate[2])),'credit')
    
    totalS <-data.frame(c(sum(debitTrans$amount),sum(creditTrans$amount)),c("Expense (debit)","Income (credit)"))
    
    colnames(totalS)<- c("amount", "type")
    
    ggplot(totalS, aes(y=type, x=amount, fill=type)) + 
      geom_bar(stat='identity',position = "stack") +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1)) +
      scale_x_continuous(labels=fancy_scientific)
    
  })
  
  output$Total <- renderPlot({
    totalTrans()
  })
  
  fancy_scientific <- function(l) {
    # turn in to character string in scientific notation
    l <- format(l, scientific = TRUE)
    # quote the part before the exponent to keep all the digits
    l <- gsub("^(.*)e", "'\\1'e", l)
    # turn the 'e+' into plotmath format
    l <- gsub("e", "%*%10^", l)
    # return this as an expression

    parse(text=l)
  }
  
  
}

shinyApp(ui,server)

