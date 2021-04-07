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
          "Second Page",
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
                fluidPage(box(
                  width = 12, dataTableOutput('results1')
                ))),
        
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
  

  # @Swetha
  # Function:  renderDataTable 
  # Component: UI
  # Variable: Local  
  output$results1 <-  DT::renderDataTable({
    datatable(mtcars, options = list(autoWidth = TRUE,
                                     searching = FALSE))
  })
  
  
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
          passwrd,
          "'"
          )
        )
    
    if (!dbHasCompleted(rs)) {
      chunk <- dbFetch(rs, n = 1)
      
      # ###########################################################
      # The row below is For Testing, and debugging Only
      # It will display the status of the component to the Console
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
    
    # Clear the connection and stop the application
    dbClearResult(rs)
    dbDisconnect(mydb)
    return(isValid)
  }
  # End of validateCredential function
  
  
}

# @Swetha @Truc
#
# Function: run App will run shiny app in the web browser
# Component: UI
# Variable: Global
runApp(list(ui = ui, server = server), launch.browser = TRUE)