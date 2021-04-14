# @ Author: Truc, Swetha, Wrucha


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

# @ Truc
# Source Script to support application UI, and Logic
source("modules/charts_module.R")
source("modules/print_display_module.R")
source("modules/user_checking_accounts.R")

# @ Swetha
# Source Script to support application UI, Logic on Login Page
source("modules/login_module.R")


# @Wrucha
# Source for setup and communicate with database system
source("modules/DataClasses.R")
source("modules/TransactionFunctions.R")
source("modules/UserFunctions.R")


# @Truc
#
# Function: getConnection, Create User data banking Account
# Component: Logic
# Variable: Global
connection<-getConnection()
UserData.Tidy<-geUsertBankTrans(connection)
TotalBalance<-getTotalBalance(UserData.Tidy)


# Validate everytime user login
login = FALSE
id = 1
USER <- reactiveValues(login = login,
                       id=id)


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
                        
                        connection<-getConnection()
                        
                        USER$id <- getUserID(Username, Password, connection)
                        
                        
                        #userInfo$Data <-  getUserInfo(Username, Password)
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
    
    
    UserTransaction<-reactive({
        conn <- getConnection()
        getTransactionDataWithStoreName(conn,USER$id)})
    
    
    
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
                    "User Information",
                    tabName = "second",
                    icon = icon("th")))}
    })
    # End output$sidebarpanel
    
    
    # @Truc @Swetha
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
    
    
    
    
    
    # @Truc
    # Function:  WelcomePage 
    # Component: UI, where the regular user interact with data and UI
    # Variable: Local
    welcomePage <- fluidPage(
        DT::dataTableOutput("transtable2")
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
        
        rs <-dbSendQuery(connection,
            paste0( "select user_id from user_details where login_username='",
                username ,"' and login_password = '",passwrd,"'"))
        
        if (!dbHasCompleted(rs)) {
            chunk <- dbFetch(rs, n = 1)
            
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
        dbDisconnect(connection)
        return(isValid)
    }
    # End of validateCredential function
    
    
    output$transtable2 <- DT::renderDataTable({
        df<-UserTransaction()
        df
    })
}


# @Swetha @Truc
#
# Function: run App will run shiny app in the web browser
# Component: UI
# Variable: Global
runApp(list(ui = ui, server = server), launch.browser = TRUE)