#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# library

library(shiny)
library(shinydashboard)
library(shinythemes)

library(dplyr)
library(DT)
library(ggplot2)

library(plotly)
library(readr)

library(tidyverse)
library(leaflet)
library(plotrix)

UserDataOrg <-
    read_csv(
        "data/Chase2107_Activity_20210306.CSV",
        col_types = cols(`Posting Date` = col_date(format = "%m/%d/%Y"))
    )

UserDataOrg$Type <- NULL

UserDataOrg <-UserDataOrg %>% rename(c(type = Details,date = `Posting Date`,
                                       amount = Amount, balance = Balance, description=Description ))
UserData <- UserDataOrg

UserData$description <- NULL

# Create explicit data frame for modification, and display
Total <- aggregate(select(UserData, -c(type))['balance'], select(UserData, -c(type))['date'], last)

# Main UI
ui <- fluidPage(
  
  # Theme theme
  theme = shinytheme("flatly"),
  
  navbarPage("Personal Expense Analyst",
             tabPanel("About Us"),
             navbarMenu("Setting",
                        tabPanel("Summary"),
                        "----",
                        "Section header",
                        tabPanel("Table")
             )
  ),
  # Application title
  titlePanel("Expense Analyst"),
  
  
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        'input.dataset === "User Expense"',
        checkboxGroupInput("show_vars", "Columns To Show:",
                           names(UserDataOrg), selected = names(UserDataOrg)),
        
        # Add on Feature
        actionButton("add", "Add Transaction"),
        actionButton("remove", "Remove transaction"),
        numericInput("serving", "Number of servings contained", min = 0.01, step = 1, value = 1),
        
      ),
      conditionalPanel(
        'input.dataset === "Analyst"',
        
        #------------------------------------------------------------
        tags$h3("View by Transaction Amount",class="text-info"),
        # Show a plot of the generated distribution
        tags$p("Note: Move the slider to see the frequency of the total balance in your bank account."),
        sliderInput("bins","Number of bins:",
                    min = 1,max = 100,value = 30),
        tags$br(),tags$br(),
        tags$hr(),
        
        #------------------------------------------------------------
        tags$h3("Total Balance",class="text-info"),
        # Select date range to be plotted
        tags$p("Note: Choose date to see the total balance between a specific time!"),
        dateRangeInput("date1",strong("Date range"),start = "2019-03-06",end = "2021-03-05",
                       min = "2019-03-06",max = "2021-03-05"),
        tags$br(),tags$br(),
        tags$hr(),
        
        #------------------------------------------------------------
        
        tags$h3("Transaction By Category",class="text-info"),
        
        tags$div(
          tags$p("Select one of the following option:"),
          tags$li("DEBIT: debit balances include assets, expenses, and losses..."),
          tags$li("CREDIT: credit balances include incomes, revenue accounts, and gain accounts..."),
          tags$li("CHECK: Deposit of check(s)."),
          tags$li("DSLIP: Deposit slips (check or cash)."),
          tags$br(),),
        
        # Select type of trend to plot
        selectInput(inputId = "type",label = strong("Type of Transaction"),
                    choices = unique(c('DEBIT', 'CREDIT', 'CHECK', 'DSLIP')), selected = "DEBIT" ),
        
        # Select date range to be plotted
        dateRangeInput("date", strong("Date range"), start = "2019-03-06", end = "2021-03-05",
                       min = "2019-03-06",max = "2021-03-05"),
        
        # Select whether to overlay smooth trend line
        checkboxInput( inputId = "smoother", label = strong("Overlay smooth trend line"),
                       value = FALSE),
        
        # Display only if the smoother is checked
        conditionalPanel(condition = "input.smoother == true",
                         sliderInput( inputId = "f",label = "Smoother span:",
                                      min = 0.01, max = 1, value = 0.67,step = 0.01,
                                      animate = animationOptions(interval = 100)),
                         HTML("Higher values give more smoothness.")),
        tags$p("Note:"),
        
        tags$br(),tags$br(),
        tags$hr(),
        #------------------------------------------------------------
      ),
      tags$div(
        tags$p("Support:"),
        tags$li("Truc Huynh business services: 800-242-7338."),
        tags$li("For online technical support, please call us at 1-877-242-7372"),
        tags$li("For help with online banking, please  contact us online"))
      
    ),
    
    
    mainPanel(
      tabsetPanel(
        id = 'dataset',
        tabPanel("User Expense", DT::dataTableOutput("mytable1")),
        tabPanel("General Analyst", 
                 plotOutput("distPlot", height = "300px"),
                 plotOutput("lineplot1", height = "300px"),
                 plotOutput("lineplot"),
                 tags$a(href = "https://github.com/jackyhuynh", "Source: Private Data from Truc")),
        tabPanel("Category Analyst",
                 plotOutput("pieplot"),
                 height = "300px"
        ),
        tabPanel("Map",
                 leafletOutput("map"),
        )
      )
    )
    
    
    
  )
)

# Define server logic for the web app
server <- function(input, output) {
  # choose columns to display
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(UserDataOrg[, input$show_vars, drop = FALSE])
  })
  
    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- Total[,2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'azure3', border = 'white', xlab = "Balance")
    })
    
    # Validate the date before plot
    selected_User1 <- reactive({
        req(input$date1)
        validate(need(!is.na(input$date1[1]) & !is.na(input$date1[2]),"Error: Please provide both a start and an end date."))
        validate(need(input$date1[1] < input$date1[2],"Error: Start date should be earlier than end date."))
        Total %>% filter(date > (input$date1[1]) & date < (input$date1[2]))
    })
    
    # Plot the total balance
    output$lineplot1 <- renderPlot({
        color = "azure4"
        par(mar = c(4, 4, 1, 1))
        plot(x = selected_User1()$date, y = selected_User1()$balance, type = "o",
                xlab = "Date", ylab = "Total Balance",col = color, fg = color, col.lab = color, col.axis = color)
        smooth_curve <- lowess(x = as.numeric(selected_User1()$date), y = selected_User1()$balance)
        lines(smooth_curve, col = "#E6553A", lwd = 3)
        
    })
    
    # Subset data, validate the input date to make sure user enter the valid date
    selected_User <- reactive({
        req(input$date)
        
        validate(need(!is.na(input$date[1]) & !is.na(input$date[2]), "Error: Please provide both a start and an end date."))
        
        validate(need(input$date[1] < input$date[2], "Error: Start date should be earlier than end date."))
        
        if(input$type=='DEBIT')
        {
            UserDebit <-
                aggregate(select(UserData[UserData$type == 'DEBIT', ], -type)['amount'], by =
                              select(UserData[UserData$type == 'DEBIT', ], -type)['date'], sum)
            
            UserDebit%>%
                filter(date > input$date[1] & date < input$date[2])
        }else if(input$type=='CREDIT')
        { 
            UserCredit <-
                aggregate(select(UserData[UserData$type == 'CREDIT', ], -type)['amount'], by =
                              select(UserData[UserData$type == 'CREDIT', ], -type)['date'], sum)
            UserCredit%>%
                filter(date > input$date[1] & date < input$date[2])
        }else if(input$type=='CHECK')
        {
            UserCheck <-
                aggregate(select(UserData[UserData$type == 'CHECK', ], -type)['amount'], by =
                              select(UserData[UserData$type == 'CHECK', ], -type)['date'], sum)
            UserCheck%>%
                filter(date > input$date[1] & date < input$date[2])
        }else
        {
          UserDSLIP <-
            aggregate(select(UserData[UserData$type == 'DSLIP', ], -type)['amount'], by =
                        select(UserData[UserData$type == 'DSLIP', ], -type)['date'], sum)
            UserDSLIP%>%
                filter(date > input$date[1] & date < input$date[2])
        }
    })
    
    # Create scatterplot object the plotOutput function is expecting
    output$lineplot <- renderPlot({
        color = "#434343"
        par(mar = c(4, 4, 1, 1))
        plot(x = selected_User()$date, y = selected_User()$amount, type = "l",
             xlab = "Date", ylab = "Amount", col = color, fg = color, col.lab = color, col.axis = color)
        # Display only if smoother is checked
        if(input$smoother){
            smooth_curve <- lowess(x = as.numeric(selected_User()$date), y = selected_User()$amount, f = input$f)
            lines(smooth_curve, col = "#E6553A", lwd = 3)
        }
    })
    
    points <- eventReactive(input$recalc, {
        cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
    }, ignoreNULL = FALSE)
    
    location <- read_csv("data/location.csv")
    
    output$map <- renderLeaflet({
        leaflet(data = location) %>% addTiles() %>%
            addMarkers(~long, ~lat, popup =~as.character(Amount), label = ~as.character(store))
    })
    
    # import the data
    transactions <- read_csv("data/transactions.csv")
    
    # Summary by debit and type
    UserTransaction <-
      aggregate(select(transactions[transactions$type == 'debit', ], -type)['Amount'], by =
                  select(transactions[transactions$type == 'debit', ], -type)['category'], sum)
    
    # Filter the big transaction
    SumTransaction <- filter(UserTransaction, as.numeric(UserTransaction$Amount/sum(UserTransaction$Amount)) > 0.005)
    
    # Calculate the percentage of all Transactions smaller than 1 percent
    OtherTransaction <- data.frame("Other Expenses",
                                   sum(UserTransaction$Amount) - sum(SumTransaction$Amount))
    
    # Rename the value
    names(OtherTransaction) <- c('category','Amount')
    
    # Get the total transaction after summary the transaction less than 1 percent
    SumTransaction<- rbind(SumTransaction,OtherTransaction)
    
    # Sort the SumTransaction
    SumTransaction <- SumTransaction[order(-SumTransaction[,2]),]
    
    piepercent <- scales::percent(as.numeric(SumTransaction$Amount/sum(SumTransaction$Amount)))
    
    output$pieplot <- renderPlot({
      par(mar = c(1, 1, 1, 1)) # bltr
      pie(
        SumTransaction$Amount,
        edges = 200,
        radius = 0.8,
        clockwise = TRUE,
        # IMPORTANT
        angle = 45,
        col = viridis::viridis_pal(option = "magma", direction = -1)(length(SumTransaction$Amount)),
        # BETTER COLOR PALETTE
        labels = head(piepercent,-3),
        # NEVER DISPLAY OVERLAPPING LABELS
        cex = 0.7,
        border = "white",
      )
      
      legend(
        1,
        .5,
        SumTransaction$category,
        cex = 0.7,
        fill = viridis::viridis_pal(option = "magma", direction = -1)(length(SumTransaction$Amount))
      )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
