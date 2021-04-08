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
#source("modules/checking_sample.R")
source("modules/CategoryFunctions.R")
source("modules/DataClasses.R")
source("modules/TransactionFunctions.R")
source("modules/UserFunctions.R")


# The original data is used for display only
UserData.Tidy  <- read_csv("data/data.CSV", col_types = cols(date = col_date(format = "%m/%d/%Y")))

# Set the Type to NULL
UserData.Tidy$type <- NULL

# The total balance over time
TotalBalance <-
  aggregate(select(UserData.Tidy,-c(details))['balance'], select(UserData.Tidy,-c(details))['date'], last)

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
  
  
  # Validate everytime user login
  USER <- reactiveValues(login = login)
  
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
  # Monitor and control action of the User Banking Panel
  checkingAccountUI<-conditionalPanel(
    'input.dataset === "Checking Account"',
    checkboxGroupInput(
      "show_trans",
      "Selections:",
      names(UserData.Tidy),
      selected = names(UserData.Tidy)
    )
  )
  
  allTransactionsUI<-  conditionalPanel(
          'input.dataset === "All Transaction"',
          
        )
    
    
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
        conditionalPanel(
          'input.dataset === "Expense vs. Income"',
          tags$h3("Total Income vs. Expense Over Time", class = "text-info"),
          # Select date range to be plotted
          tags$p("Note: Choose date to see the total balance between a specific time!")
          ),
        # Simply print the Authority in main pages
        printMainAuthority()
        
      ),
      mainPanel(id = 'dataset',
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
                          ),),
                        
                        mainPanel(plotOutput("lineplot1", height = "300px",click="lineplot1_click"),
                                  verbatimTextOutput("lineplot1Info"),
                                  tags$p("Note: Please click on the chart to see the amount in US Dollar($)!"),
                        ))
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
                )
      )
      # End mainPanel id = 'dataset'
    )
    # End sidebarLayout
  )
  
  

  
  
  ###################
  # @LOGIC FUNCTIONS:
  ###################
  
  # @ SET OF LOGIC VALIDATION
  
  # @Swetha
  # Function:  validateCredentails will 
  # Component: Logic, Validate user login's information and etablish connection to
  #            the database
  # Variable: Local  
  validateCredentails <- function(userid, passwrd) {
    
    # print("inside validateCredentails")
    # print(userid)
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
          passwrd,
          "'"
          )
        )
    
    if (!dbHasCompleted(rs)) {
      chunk <- dbFetch(rs, n = 1)
  
      print(nrow(chunk))
      if (nrow(chunk) == 1) {
        #print("Authentication SUCCESSFUL")
        isValid <- TRUE
      }
      else {
        #print("Authentication FAILED")
        isValid <- FALSE
      }
      
    }
    
    # Clear the connection and stop the application
    dbClearResult(rs)
    dbDisconnect(mydb)
    return(isValid)
  }
  # End of validateCredential function
  
}
# End Server function


# @Swetha @Truc
#
# Function: run App will run shiny app in the web browser
# Component: UI
# Variable: Global
runApp(list(ui = ui, server = server), launch.browser = TRUE)