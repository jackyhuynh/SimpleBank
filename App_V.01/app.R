library(shiny)
library(shinydashboard)
library(shinythemes) # themes for css

library(dplyr)
library(DT)

library(shinyjs)
library(sodium)
library(shinyauthr)
library(odbc)
library(RMySQL)
library(sqldf)

library(ggplot2) # plot
library(plotly) # plot
library(readr) # read data in
library(tidyverse) # pipe
library(leaflet) # map

source("modules/pie_chart_module.R")
source("modules/print_display_module.R")

# The original data is used for display only
UserData.Tidy  <- read_csv("data/data.CSV", col_types = cols(date = col_date(format = "%m/%d/%Y")))

# Get the Transaction Database
UserTransaction <- read_csv("data/transdata.csv",col_types = cols(date = col_date(format = "%m/%d/%Y")))

# Set the Type to NULL
UserData.Tidy$type <- NULL

# The total balance over time
TotalBalance <-
  aggregate(select(UserData.Tidy,-c(details))['balance'], select(UserData.Tidy,-c(details))['date'], last)

# Main login screen
loginpage <-
  div(
    id = "loginpage",
    style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
    wellPanel(
      tags$h2("LOG IN", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
      textInput(
        "userName",
        placeholder = "Username",
        label = tagList(icon("user"), "Username")
      ),
      passwordInput(
        "passwd",
        placeholder = "Password",
        label = tagList(icon("unlock-alt"), "Password")
      ),
      br(),
      div(
        style = "text-align: center;",
        actionButton(
          "login",
          "SIGN IN",
          style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;"
        ),
        shinyjs::hidden(div(
          id = "nomatch",
          tags$p(
            "Incorrect username or password!",
            style = "color: red; font-weight: 600;
                                            padding-top: 5px;font-size:16px;",
            class = "text-center"
          )
        )),
        br()
      )
    )
  )

# Ignore lines 64-68 as they contain static user data
credentials = data.frame(
  username_id = c("myuser", "myuser1"),
  passod   = sapply(c("mypass", "mypass1"), password_store),
  permission  = c("basic", "advanced"),
  stringsAsFactors = F
)

header <-
  dashboardHeader(title = "Financial Freedom", uiOutput("logoutbtn"))

sidebar <- dashboardSidebar(uiOutput("sidebarpanel"))
body <- dashboardBody(shinyjs::useShinyjs(), uiOutput("body"))
ui <- dashboardPage(
  dashboardHeader(title = "Financial Freedom", uiOutput("logoutbtn")),
  dashboardSidebar(uiOutput("sidebarpanel")), 
  dashboardBody(shinyjs::useShinyjs(), uiOutput("body")), 
  skin = "blue")

server <- function(input, output, session) {
  login = FALSE
  USER <- reactiveValues(login = login)

    
  observe({
    if (USER$login == FALSE) {
      if (!is.null(input$login)) {
        if (input$login > 0) {
          Username <- isolate(input$userName)
          Password <- isolate(input$passwd)
          pasverify <-
            validateCredentails(Username, Password) # Authentication function
          
          if (pasverify) {
            USER$login <- TRUE
          } else {
            shinyjs::toggle(
              id = "nomatch",
              anim = TRUE,
              time = 1,
              animType = "fade"
            )
            shinyjs::delay(
              3000,
              shinyjs::toggle(
                id = "nomatch",
                anim = TRUE,
                time = 1,
                animType = "fade"
              )
            )
          }
          
        }
      }
    }
  })
  
  output$logoutbtn <- renderUI({
    req(USER$login)
    tags$li(
      a(icon("fa fa-sign-out"), "Logout",
        href = "javascript:window.location.reload(true)"),
      class = "dropdown",
      style = "background-color: #eee !important; border: 0;
                    font-weight: bold; margin:5px; padding: 10px;"
    )
  })
  
  #
  output$sidebarpanel <- renderUI({
    if (USER$login == TRUE) {
      sidebarMenu(
        menuItem(
          "Main Page",
          tabName = "dashboard",
          icon = icon("dashboard")
        ),
        menuItem(
          "Second Page",
          tabName = "second",
          icon = icon("th")
        )
      )
    }
  })
  
# Please modify code for welcome page in this section
  
  
  output$body <- renderUI({
    if (USER$login == TRUE) {
      tabItems(
        # First tab
        tabItem(tabName = "dashboard", class = "active",
                
                # Fluid Page for the main User Home Page
                fluidPage(
                  # Add UI theme, can easily change theme by change the UI
                  theme = shinytheme("flatly"),
                  
                  # Application title
                  titlePanel("Deep Financial Analysis"),
                  
                  # sidebar Design
                  sidebarLayout(
                    sidebarPanel (
                      width = 3,
                      
                      # Monitor and control action of the User Bank Panel
                      conditionalPanel(
                        'input.dataset === "Checking Account"',
                        checkboxGroupInput(
                          "show_trans",
                          "Selections:",
                          names(UserData.Tidy),
                          selected = names(UserData.Tidy)
                        )
                      ),
                      
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
                      
                      # Monitor and control the action of all Transactions Panel
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
                        )),
                      # Simply print the Authority in main pages
                      printMainAuthority()
                    ),
                    
                    mainPanel (tabsetPanel(
                      id = 'dataset',
                      
                      # Checking Account
                      tabPanel(
                        "Checking Account",
                        DT::dataTableOutput("bankTable"),
                        
                        printWhiteSpace(),
                        tags$em(tags$h3("Deep Analyzing", class = "text-primary")),
                        
                        # Inside UI to display the tabset
                        tabsetPanel(
                          id = 'bankset',
                          
                          # Inside bankset tab Transaction Amount Tabset
                          tabPanel(
                            "Analyze by Transaction Amount",
                            sidebarLayout(
                              #side bar Panel
                              sidebarPanel(
                                tags$h3("View by Transaction Amount", class = "text-info"),
                                tags$p("Note: Move the slider to see the frequency of the total balance in your bank account."),
                                sliderInput(
                                  "bins","Number of bins:",min = 1,max = 100,value = 30),),
                              
                              #main Panel of Transaction Amount Tabset
                              mainPanel(plotOutput("distPlot", height = "300px"))
                            )
                          ),
                          # end sidebarLayout "Transaction Amount"
                          
                          # Inside bankset tab Analyze by Total Balance Tabset
                          tabPanel(
                            "Analyze by Total Balance",
                            sidebarLayout(
                              sidebarPanel(
                                tags$h3("Total Balance Over Time", class = "text-info"),
                                # Select date range to be plotted
                                tags$p("Note: Choose date to see the total balance between a specific time!"),
                                dateRangeInput(
                                  "date1", strong("Date range"),
                                  start = min(UserData.Tidy$date),
                                  end = max(UserData.Tidy$date),
                                  min = min(UserData.Tidy$date),
                                  max = max(UserData.Tidy$date)
                                ),
                                
                                # Select whether to overlay smooth trend line
                                checkboxInput(
                                  inputId = "smootherTotal",
                                  label = strong("Overlay smooth trend line"),
                                  value = FALSE
                                ),
                              ),
                              mainPanel(plotOutput("lineplot1", height = "300px",click="lineplot1_click"),
                                        verbatimTextOutput("lineplot1Info"),
                                        tags$p("Note: Please click on the chart to see the amount in US Dollar($)!"),
                              )
                              
                            )
                          ),
                          # end sidebarLayout "Total Balance"
                          
                          tabPanel(
                            "Analyze by Category",
                            sidebarLayout(
                              sidebarPanel(
                                tags$h3("Transaction By Category", class = "text-info"),
                                
                                # Select type of trend to plot
                                selectInput(
                                  inputId = "type",
                                  label = strong("Type of Transaction"),
                                  choices = unique(c('DEBIT', 'CREDIT', 'CHECK', 'DSLIP')),
                                  selected = "DEBIT"
                                ),
                                
                                # Select date range to be plotted
                                dateRangeInput(
                                  "date",
                                  strong("Date range"),
                                  start = min(TotalBalance$date),
                                  end = max(TotalBalance$date),
                                  min = min(TotalBalance$date),
                                  max = max(TotalBalance$date)
                                ),
                                
                                # Select whether to overlay smooth trend line
                                checkboxInput(
                                  inputId = "smoother",
                                  label = strong("Overlay smooth trend line"),
                                  value = FALSE
                                ),
                                
                                # Display only if the smoother is checked
                                conditionalPanel(
                                  condition = "input.smoother == true",
                                  sliderInput(
                                    inputId = "f",
                                    label = "Smoother span:",
                                    min = 0.01,
                                    max = 1,
                                    value = 0.67,
                                    step = 0.01,
                                    animate = animationOptions(interval = 100)
                                  ),
                                  HTML("Higher values give more smoothness.")
                                ),
                                
                                
                              ),
                              mainPanel (plotOutput("lineplot", height = "300px",click = "lineplot_click"),
                                         verbatimTextOutput("lineplotInfo"),
                                         tags$p("Note: Please click on the chart to see the amount in US Dollar($)!")
                              )
                              
                            ),
                            noteCategory(),
                          )
                        )
                      ),
                      
                      ################################################
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
                        
                      ), # End TabPanel All Transaction
                      
                      
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
                               
                      ) # End tab Panel Total Expense
                    ))),# end all Tabs
                  
                  # Decoration function
                  printWhiteSpace(),
                  tags$hr(),
                  printNote(),
                  printWhiteSpace()         
                  
                )),
        
        # Second tab
        tabItem(tabName = "second",
                fluidRow(box(
                  width = 12, dataTableOutput('results2')
                )))
      )
      
    }
    else {
      loginpage
    }
  })
  
  output$results2 <-  DT::renderDataTable({
    datatable(mtcars, options = list(autoWidth = TRUE,
                                     searching = FALSE))
  })
  
  validateCredentails <- function(userid, passwrd) {
    print("inside validateCredentails")
    print(userid)
    drv <- dbDriver("MySQL")
    isValid <- FALSE
    mydb <-
      dbConnect(
        drv,
        user = 'root',
        password = 'Myskhongbiet88',
        dbname = 'credit_card_analysis2',
        host = 'localhost'
      )
    
    rs <-
      dbSendQuery(
        mydb,
        paste0(
          "select user_id from user_details where login_username='",
          userid ,
          "' and login_password = '",
          passwrd ,
          "'"
        )
      )
    
    if (!dbHasCompleted(rs)) {
      chunk <- dbFetch(rs, n = 1)
      
      print(nrow(chunk))
      if (nrow(chunk) == 1) {
        print("Authentication SUCCESSFUL")
        isValid <- TRUE
      }
      else {
        print("Authentication FAILED")
        isValid <- FALSE
      }
    }
    dbClearResult(rs)
    dbDisconnect(mydb)
    return(isValid)
  }
  
  
  
  output$bankTable <- DT::renderDataTable({
    DT::datatable(UserData.Tidy[, input$show_trans, drop = FALSE])
  })
  
  output$transTable <- DT::renderDataTable({
    DT::datatable(UserTransaction[, input$show_trans2, drop = FALSE])
  })
  
  # Plot1: Plot the frequency transaction
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- TotalBalance[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(
      x,
      breaks = bins,
      col = 'azure3',
      border = 'white',
      xlab = "Balance",
      main = ""
    )
  })
  
  
  # Plot2:Validate the date before plot
  selected_User1 <- reactive({
    req(input$date1)
    validate(need(
      !is.na(input$date1[1]) &
        !is.na(input$date1[2]),
      "Error: Please provide both a start and an end date."
    ))
    validate(
      need(
        input$date1[1] < input$date1[2],
        "Error: Start date should be earlier than end date."
      )
    )
    TotalBalance %>% filter(date > (input$date1[1]) &
                              date < (input$date1[2]))
  })
  
  # Plot2: Plot the total balance
  output$lineplot1 <- renderPlot({
    color = "azure4"
    par(mar = c(4, 4, 1, 1))
    plot(
      x = selected_User1()$date,
      y = selected_User1()$balance,
      type = "o",
      xlab = "Date",
      ylab = "Total Balance",
      col = color,
      fg = color,
      col.lab = color,
      col.axis = color
    )
    # Add the smooth_curve
    if (input$smootherTotal) {
      smooth_curve <-
        lowess(x = as.numeric(selected_User1()$date),
               y = selected_User1()$balance)
      lines(smooth_curve, col = "#E6553A", lwd = 3)}
    
  })
  
  #Display the total input click
  output$lineplot1Info <- renderText({
    paste0("Amount = $ ", round(as.numeric(input$lineplot1_click$y),2))
  })
  
  # plot3:
  selected_User <- reactive({
    req(input$date)
    
    validate(need(
      !is.na(input$date[1]) &
        !is.na(input$date[2]),
      "Error: Please provide both a start and an end date."
    ))
    
    validate(need(
      input$date[1] < input$date[2],
      "Error: Start date should be earlier than end date."
    ))
    
    if (input$type == 'DEBIT')
    {
      UserDebit <-
        aggregate(select(UserData.Tidy[UserData.Tidy$details == 'DEBIT',],-details)['amount'],
                  by =
                    select(UserData.Tidy[UserData.Tidy$details == 'DEBIT',],-details)['date'],
                  sum)
      
      UserDebit %>%
        filter(date > input$date[1] & date < input$date[2])
    } else if (input$type == 'CREDIT')
    {
      UserCredit <-
        aggregate(select(UserData.Tidy[UserData.Tidy$details == 'CREDIT',],-details)['amount'],
                  by =
                    select(UserData.Tidy[UserData.Tidy$details == 'CREDIT',],-details)['date'],
                  sum)
      UserCredit %>%
        filter(date > input$date[1] & date < input$date[2])
    } else if (input$type == 'CHECK')
    {
      UserCheck <-
        aggregate(select(UserData.Tidy[UserData.Tidy$details == 'CHECK',],-details)['amount'],
                  by =
                    select(UserData.Tidy[UserData.Tidy$details == 'CHECK',],-details)['date'],
                  sum)
      UserCheck %>%
        filter(date > input$date[1] & date < input$date[2])
    } else
    {
      UserDSLIP <-
        aggregate(select(UserData.Tidy[UserData.Tidy$details == 'DSLIP',],-details)['amount'],
                  by =
                    select(UserData.Tidy[UserData.Tidy$details == 'DSLIP',],-details)['date'],
                  sum)
      UserDSLIP %>%
        filter(date > input$date[1] & date < input$date[2])
    }
  })
  
  # Plot3: Create scatterplot object the plotOutput function is expecting
  output$lineplot <- renderPlot({
    color = "#434343"
    par(mar = c(4, 4, 1, 1))
    plot(
      x = selected_User()$date,
      y = selected_User()$amount,
      type = "o",
      xlab = "Date",
      ylab = "Amount",
      col = color,
      fg = color,
      col.lab = color,
      col.axis = color
    )
    # Display only if smoother is checked
    if (input$smoother) {
      smooth_curve <-
        lowess(
          x = as.numeric(selected_User()$date),
          y = selected_User()$amount,
          f = input$f
        )
      lines(smooth_curve, col = "#E6553A", lwd = 3)
    }
  })
  
  #Display the total input click of lineplot
  output$lineplotInfo <- renderText({
    paste0("Amount: $ ", round(as.numeric(input$lineplot_click$y),2))
  })
  
  
  # Set of methods for the Summary map
  location <-
    aggregate(amount ~ lat + long,data = filter(UserTransaction, UserTransaction$type == 'debit'),FUN = sum)
  
  output$map <- renderLeaflet({
    leaflet(data = location) %>% addTiles() %>%
      addMarkers( ~ long, ~ lat, label =  ~ as.character(amount))
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

runApp(list(ui = ui, server = server), launch.browser = TRUE)