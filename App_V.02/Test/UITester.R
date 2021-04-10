library(shiny)

connection<-getConnection()

UserTransaction<-getTransactions(1,connection)

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
    
}

shinyApp(ui,server)

