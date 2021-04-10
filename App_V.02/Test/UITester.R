library(shiny)

connection<-getConnection()

UserTransaction<-getTransactions(1,connection)

connection<-getConnection()
FWlocation <- getFortWayneLocations(connection)

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
      )
    ),
    mainPanel(
      #All Transaction
      tabPanel(
        "All Transaction",
        DT::dataTableOutput("transTable"),
        
        printWhiteSpace(),
        tags$em(tags$h3("Deep Analyzing", class = "text-primary")),
        
        tabsetPanel(
          tabPanel("Map Expense",leafletOutput("map")),
          tabPanel("Total Income")
        ) # End tabset Panel
      )
    )
  )
)

server<-function(input,output, session){
  output$transTable <- DT::renderDataTable({
    DT::datatable(UserTransaction[, input$show_trans2, drop = FALSE])
  })
  
  # Set of methods for the Summary map
  location <-
    aggregate(amount ~ lat + long,data = UserTransaction,FUN = sum)

  location <- merge(location, FWlocation)
  titles<-location$store
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
    
    totalS <-data.frame(c(sum(debitTrans$amount),sum(creditTrans$amount)),c("Expense","Income"))
    
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

