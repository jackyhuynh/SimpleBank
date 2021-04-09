# @ Author: Truc, Swetha


# Require library
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


# Source file for category
source("modules/pie_chart_module.R")
source("modules/print_display_module.R")
source("modules/checking_sample.R")
source("modules/CategoryFunctions.R")
source("modules/DataClasses.R")
source("modules/TransactionFunctions.R")
source("modules/UserFunctions.R")


# @Swetha
#
# Name: Main login screen
# Function: UI Component for Login Screen
# Component: UI
# Variable: Global
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
# End Main Login UI


#  @Swetha
# 
# Function: Ignore lines 64-68 as they contain static user data
# Component: UI
# Variable: Global
credentials = data.frame(
  username_id = c("myuser", "myuser1"),
  passod   = sapply(c("mypass", "mypass1"), password_store),
  permission  = c("basic", "advanced"),
  stringsAsFactors = F
)


labelMandatory <- function(label) {
  tagList(label,span("*", class = "mandatory_star")
  )}


# @Swetha
#
# Function: ui dashboard for the main page
# Component: UI
# Variable: Global
ui <- dashboardPage(
  # @Swetha
  #
  # Function: Top header, sidebar, and body for the Dashboard
  # Component: UI
  # Variable: Global
  dashboardHeader(title = "Financial Freedom", uiOutput("logoutbtn")),
  dashboardSidebar(uiOutput("sidebarpanel")),
  dashboardBody(shinyjs::useShinyjs(), uiOutput("body")),
  skin = "blue"
)
# end ui function


# @Swetha @Truc
#
# Function: Server logic that handle the application
# Component: Server and Logic Component
# Variable: Global
server <- function(input, output, session) {
  
  # login variable for user to login
  login = FALSE
  id = 1
  Data <- NULL
  
  # Validate everytime user login
  USER <- reactiveValues(login = login , id = id, Data = Data)

  
  # @Swetha 
  #
  # Function: Adding component
  # Component: Logic, Part of user login validation
  # Variable: Local
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
            USER$Data <-  getUserInfo(Username, Password)
          } else {
            shinyjs::toggle(
              id = "nomatch",
              anim = TRUE,
              time = 1,
              animType = "fade"
            )
            shinyjs::delay(3000,
                           shinyjs::toggle(
                             id = "nomatch",
                             anim = TRUE,
                             time = 1,
                             animType = "fade"
                           ))}}}}
  }) 
  # end observe for user login
  
  
  ###################
  # @UI COMPONENTS:
  ###################
  
  
  # @SET OF LOGIN PAGE UI
  
  
  # @Swetha 
  #
  # Function: Log out button for Welcome Page
  # Component: UI, part of user Welcome Page UI
  # Variable: Local
  output$logoutbtn <- renderUI({
    req(USER$login)
    tags$li(
      a(icon("fa fa-sign-out"), "Logout",
        href = "javascript:window.location.reload(true)"),
      class = "dropdown",
      style = "background-color: #eee !important; border: 0;
       font-weight: bold; margin:5px; padding: 10px;")
  }) 
  # End output$logoutbtn 
  
  
  # @Swetha 
  #
  # Function: Log out button for Welcome Page
  # Component: UI, part of user Welcome Page UI
  # Variable: Local
  output$sidebarpanel <- renderUI({
    if (USER$login == TRUE) {
      sidebarMenu(
        menuItem(
          "Main Page",
          tabName = "dashboard",
          icon = icon("dashboard")
        ),
        menuItem(
          "Admin Page",
          tabName = "second",
          icon = icon("th")))}
  })
  # End output$sidebarpanel
  
  # @Truc
  #
  # Function: UI Component for the welcome page
  # Component: UI, Hold majority part of user Welcome Page UI
  #            All Chart for user Analyst
  #            List of transactions
  # Variable: Local
  output$body <- renderUI({
    # Allow user login if suceed
    if (USER$login == TRUE) {
      tabItems(
        # First tab
        tabItem(tabName = "dashboard", class = "active",
                
                # Fluid Page for the main User Home Page
                welcomePage),
        
        # Second tab
        tabItem(tabName = "second",
                fluidRow(box(
                  width = 12, dataTableOutput('results2')
                ))))
    }
    # Call the loginpage agin if fail to identify user
    else {
      loginpage
    }
  })
  # End output$body
  
  
  # @Swetha
  # Function:  renderDataTable 
  # Component: UI
  # Variable: Local  
  output$results2 <-  DT::renderDataTable({
    datatable(mtcars, options = list(autoWidth = TRUE,
                                     searching = FALSE))
  })
  
  
  # @ SET OF MAIN PAGE (WELCOME PAGE) UI

  
  # @Truc
  # Function:  checkingAccountUI 
  # Component: UI, Monitor and view control of the User Banking List
  # Variable: Local
  checkingAccountUI<-conditionalPanel(
    'input.dataset === "Checking Account"',
    checkboxGroupInput(
      "show_trans",
      "Selections:",
      names(UserData.Tidy),
      selected = names(UserData.Tidy)
    )
  )
  # End checkingAccountUI
  
  
  # @Truc
  # Function:  allTransactionsUI 
  # Component: UI, Monitor and view control of the all transaction List
  # Variable: Local
  allTransactionsUI<-  conditionalPanel(
          'input.dataset === "All Transaction"')
   
   
  # @Truc
  # Function:  expenseVsIncomeUI 
  # Component: UI, Monitor and view control of the expense vs. Income Analyst
  # Variable: Local
  expenseVsIncomeUI <- conditionalPanel(
    'input.dataset === "Expense vs. Income"',
    tags$h3("Total Income vs. Expense Over Time", class = "text-info"),
    # Select date range to be plotted
    tags$p("Note: Choose date to see the total balance between a specific time!")
  )
  # End expenseVsIncomeUI
  
  
  # @Truc
  # Function:  balanceFrequencyUI 
  # Component: UI, Monitor, view control plot control Balance Frequecy tab
  # Variable: Local
  balanceFrequencyUI<-tabPanel(
    "Analyze by Balance Frequency",
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
  )
  # End balanceFrequencyUI
  
  
  # @Truc
  # Function:  totalBalanceUI 
  # Component: UI, Monitor, view control plot control Balance Total tab
  # Variable: Local
  totalBalanceUI<-tabPanel(
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
        ),),
      
      mainPanel(plotOutput("lineplot1", height = "300px",click="lineplot1_click"),
                verbatimTextOutput("lineplot1Info"),
                tags$p("Note: Please click on the chart to see the amount in US Dollar($)!"),
      ))
  )
  # End totalBalanceUI
  
  
  # @Truc
  # Function:  AnalyzeByCategoty 
  # Component: UI, Monitor, view control plot control Analyze by Category tab
  # Variable: Local
  AnalyzeByCategoty<-tabPanel(
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
                 tags$p("Note: Please click on the chart to see the amount in US Dollar($)!"))
    ),
    noteCategory(),
  )
  
  
  # Inside bankset tab Transaction Amount Tabset
  balanceFrequencyUI<-tabPanel(
    "Analyze by Balance Frequency",
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
  )
  
  
  # Inside bankset tab Analyze by Total Balance Tabset
  totalBalanceUI<-tabPanel(
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
        ),),
      
      mainPanel(plotOutput("lineplot1", height = "300px",click="lineplot1_click"),
                verbatimTextOutput("lineplot1Info"),
                tags$p("Note: Please click on the chart to see the amount in US Dollar($)!"),
      ))
  )
  # end sidebarLayout "Total Balance"
  
  
  # @Truc
  # Function:  WelcomePage 
  # Component: UI, where the regular user interact with data and UI
  # Variable: Local
  welcomePage <- fluidPage(
    # Add CSS UI theme, can easily change theme by change 
    # the theme name inside shinytheme()
    theme = shinytheme("flatly"),
    
    # Application title
    titlePanel("Deep Financial Analysis"),
    
    # UI Component that hold all 
    sidebarLayout(
      sidebarPanel(
        width = 3,
        checkingAccountUI,
        allTransactionsUI,
        expenseVsIncomeUI, # Display the Expense Vs Income Panel
        printMainAuthority() # Display the Authority in main pages
        
      ),
      
      mainPanel(
        tabsetPanel(
          id = 'dataset',
          
          # @ Truc
          # Checking Account main Panel
          tabPanel(
            "Checking Account",
            DT::dataTableOutput("bankTable"),
            
            printWhiteSpace(),
            tags$em(tags$h3("Deep Analyzing", class = "text-primary")),
            
            # Inside UI to display the tabset
            tabsetPanel(
              id = 'bankset',
              balanceFrequencyUI, # balance Frequency UI Component
              totalBalanceUI, # total Balance Overtime
              AnalyzeByCategoty # Analyze by Category with time frame
            )),
          # End "Checking Account"
          
          # @ Truc
          # All Transaction main panel
          tabPanel(
            "All Transaction",
            DT::dataTableOutput("transTable"),
                  
            printWhiteSpace(), # Display Decoration
            tags$em(tags$h3("Deep Analyzing", class = "text-primary")),
                  
            tabsetPanel(
              tabPanel("Map Expense",leafletOutput("map")),
              tabPanel("Total Income")
            )), 
          # End TabPanel All Transaction 
                
          tabPanel(
            "Expense vs. Income",
            plotOutput("piePlotDebit"),
            sidebarLayout(
              sidebarPanel (
                div(tags$h4("Goal Analyst"),
                    tags$p("Will add the goal analyst portion here!"))),
              mainPanel(plotOutput("Total")))),
          # End "Expense vs. Income"
          
          tabPanel(
            "User Account",tags$div(
              sidebarLayout(
                sidebarPanel(),
                mainPanel(
                  id="User Information",
                  
                  tags$h2("Personal Information"),br(),
                  tags$div(
                    splitLayout(
                      cellWidths = c("200px","20", "250px"),
                      cellArgs = list(style = "vertical-align: top"),
                      textInput(
                        "fullName",labelMandatory("Full Name"), placeholder = USER$Data[[2]],width = '200px'),
                      tags$div(),
                      textInput(
                        "address","Address", placeholder = USER$Data[[3]],width = '200px')
                    )
                  ),
                  tags$div(
                    splitLayout(
                      cellWidths = c("200px","20", "250px"),
                      cellArgs = list(style = "vertical-align: top"),
                      textInput(
                        "fullName","Birthday", placeholder = USER$Data[[5]],width = '200px'),
                      tags$div(),
                      textInput(
                        "address","SSN", placeholder = '*********',width = '200px')
                    )
                  ),
                  tags$h2("Account Information"),br(),
                  tags$div(
                    splitLayout(
                      cellWidths = c("200px","20", "250px"),
                      cellArgs = list(style = "vertical-align: top"),
                      textInput(
                        "fullName",labelMandatory("User Name"), placeholder = USER$Data[[6]],width = '200px'),
                      tags$div(),
                      textInput(
                        "address",labelMandatory("Password Name"), placeholder = USER$Data[[7]],width = '200px')
                    )
                  ),
                )
              )
            )
            
          )
      ))
      # End mainPanel id = 'dataset'
    )
    # End sidebarLayout
  )
  
  
  # @ SET OF ADMIN PANEL UI
  

  # @Truc
  # Function:  AdminPage 
  # Component: UI, where the admin user perform admin action interact with data and UI
  # Variable: Local
  
  
  ###################
  # @LOGIC FUNCTIONS:
  ###################
  
  
  # @ SET OF LOGIC VALIDATION
  
  
  # @Swetha
  # Function:  validateCredentails
  # Component: Logic, Validate user login's information and etablish connection to
  #            the database
  # Variable: Local  
  validateCredentails <- function(username, passwrd) {
    
    # print("inside validateCredentails")
    # print(userid)
    drv <- dbDriver("MySQL")
    isValid <- FALSE
    connection <- getConnection()
    
    rs <-
      dbSendQuery(
        connection,
        paste0(
          "select user_id from user_details where login_username='",
          username ,
          "' and login_password = '",
          passwrd,
          "'"
          )
        )

    if (!dbHasCompleted(rs)) {
      
      chunk <- dbFetch(rs, n = 1)
      
      if (nrow(chunk) == 1) {
        #print("Authentication SUCCESSFUL")
        isValid <- TRUE
        USER$id<-chunk
      }
      else {
        #print("Authentication FAILED")
        isValid <- FALSE
      }
    }
    
    # Clear the connection and stop the application

    

    dbClearResult(rs)
    dbDisconnect(connection)
    return(isValid)
  }
  # End of validateCredential function
  
  
  # @ SET OF LOGIC FOR CHECKING ACCOUNT PANEL
  
  # @Truc
  # Function:  output$bankTable 
  # Component: Logic, Render Bank Table to the UI List
  # Variable: Local 
  output$bankTable <- DT::renderDataTable({
    DT::datatable(UserData.Tidy[, input$show_trans, drop = FALSE])
  })
  # End output$bankTable
  
  
  # @Truc
  # Function:  output$distPlot
  # Component: Logic, create frequency transaction in Checking Account Panel
  #            Plot1: Plot the frequency transaction
  # Variable: Local 
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- TotalBalance[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist( x,breaks = bins,col = 'azure3',border = 'white',xlab = "Balance",main = "")
  })
  # End output$distPlot
  
  
  # @Truc
  # Function:  selected_User1
  # Component: Logic, take 2 date from user input and validate them
  #            Plot2:Validate the date before create the plot
  # Variable: Local 
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
  
  
  # @Truc
  # Function:  output$lineplot1
  # Component: Logic, Plot2: create the plot the total balance
  # Variable: Local 
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
  # output$lineplot1
  
  
  # @Truc
  # Function:  output$lineplot1Info
  # Component: Logic, create the click on static to get the transaction amount 
  # Variable: Local 
  output$lineplot1Info <- renderText({
    paste0("Amount = $ ", round(as.numeric(input$lineplot1_click$y),2))
  })
  # End 
  
  
  # @Truc
  # Function:  selected_User1
  # Component: Logic, take 2 date from user input and validate them for plot3
  #            Plot3:Validate the date before create the plot
  # Variable: Local 
  selected_User <- reactive({
    req(input$date)
    validate(need(!is.na(input$date[1]) &!is.na(input$date[2]),
      "Error: Please provide both a start and an end date."))
    validate(need(input$date[1] < input$date[2],
      "Error: Start date should be earlier than end date."))
    
    if (input$type == 'DEBIT'){
      UserDebit <-aggregate(select(UserData.Tidy[UserData.Tidy$details == 'DEBIT',],-details)['amount'],
                  by = select(UserData.Tidy[UserData.Tidy$details == 'DEBIT',],-details)['date'],sum)
      UserDebit %>%filter(date > input$date[1] & date < input$date[2])
    } 
    else if (input$type == 'CREDIT'){
      UserCredit <-aggregate(select(UserData.Tidy[UserData.Tidy$details == 'CREDIT',],-details)['amount'],
                  by = select(UserData.Tidy[UserData.Tidy$details == 'CREDIT',],-details)['date'], sum)
      UserCredit %>%filter(date > input$date[1] & date < input$date[2])
    } 
    else if (input$type == 'CHECK'){
      UserCheck <-aggregate(select(UserData.Tidy[UserData.Tidy$details == 'CHECK',],-details)['amount'],
                  by = select(UserData.Tidy[UserData.Tidy$details == 'CHECK',],-details)['date'],sum)
      UserCheck %>%filter(date > input$date[1] & date < input$date[2])
    } 
    else{
      UserDSLIP <- aggregate(select(UserData.Tidy[UserData.Tidy$details == 'DSLIP',],-details)['amount'],
                  by = select(UserData.Tidy[UserData.Tidy$details == 'DSLIP',],-details)['date'], sum)
      UserDSLIP %>% filter(date > input$date[1] & date < input$date[2])
    }
  })
  # End selected_User function
  
  # @Truc
  # Function:  output$lineplot
  # Component: Logic, Plot3: create the plot of analyze by type
  # Variable: Local 
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
  
  
  # @Truc
  # Function:  output$lineplotInfo
  # Component: Logic, create the click on static to get the transaction amount 
  # Variable: Local 
  output$lineplotInfo <- renderText({
    paste0("Amount: $ ", round(as.numeric(input$lineplot_click$y),2))
  })
  
  getUserInfo<- function(userid){
    
    # Etablish Connection
    connection<-getConnection(username, passwrd)
    rs <-dbSendQuery(
      connection,
      paste0(
        "select user_id from user_details where login_username='",
        username ,
        "' and login_password = '",
        passwrd,
        "'"
      ))
    
    # Assign the connection to
    userData <- dbFetch(rs)
    dbClearResult(rs)
    dbDisconnect(connection)
    
    return (userData)
  }
}
# End Server function


# @Swetha @Truc
#
# Function: run App will run shiny app in the web browser
# Component: UI
# Variable: Global
runApp(list(ui = ui, server = server), launch.browser = TRUE)