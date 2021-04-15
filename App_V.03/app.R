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
    
    
    # @Truc
    #
    # Function: IMPORTANT: GET USER DATA FOR ALL TRANSACTION
    # Component: Logic
    # Variable: Local
    UserTransaction<-reactive({
        conn <- getConnection()
        getTransactionDataWithStoreName(conn,USER$id)})
    
    
    # @Truc 
    #
    # Function: IMPORTANT: GET USER DATA FOR USER INFORMATION
    # Component: Logic
    # Variable: Local
    UserInformation<-reactive({
        conn <- getConnection()
        getUserInfo(USER$id,conn)
    })
    
    
    # @Truc 
    #
    # Function: IMPORTANT: GET USER CARDS FOR USER INFORMATION
    # Component: Logic
    # Variable: Local
    UserCards<-reactive({
        conn <- getConnection()
        getAllUserCards(USER$id,conn)
    })
    
    
    
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
                    "All Transaction",
                    tabName = "dashboard",
                    icon = icon("dashboard")),
                menuItem(
                    "Banking Information",
                    tabName = "second",
                    icon = icon("th")),
                menuItem(
                    "User Information",
                    tabName = "third",
                    icon = icon("info-circle")))}
    })
    # End output$sidebarpanel
    
    
    # @Truc 
    #
    # Function: UI Component for the User Information Page
    # Component: UI, Hold UI Component for UserInformation
    # Variable: Local
    UserInformationUI <- fluidPage(
        # Add CSS UI theme, can easily change theme by change 
        # the theme name inside shinytheme()
        theme = shinytheme("flatly"),
        tags$em(tags$h3("User Account Information", class = "text-primary")),
        box( width = 12,tags$div(DT::dataTableOutput("userInformation"))),
        br(),
        tags$em(tags$h3("User Cards Info", class = "text-primary")),
        box(width = 12,tags$div(DT::dataTableOutput("cardInformation"))),
        printMainAuthority()
    )
    
    
    UserBankingUI <- fluidRow()
    
    
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
                tabItem(tabName = "second"),
                
                # Third tab
                tabItem(tabName = "third",
                        UserInformationUI))
        }
        # Call the loginpage again if fail to identify user
        else {
            loginpage
        }
    })
    # End output$body

    
    
    # @Truc
    # Function:  WelcomePage 
    # Component: UI, where the regular user interact with data and UI
    # Variable: Local
    welcomePage <- fluidPage(
        # Add CSS UI theme, can easily change theme by change 
        # the theme name inside shinytheme()
        theme = shinytheme("flatly"),
        tags$em(tags$h3("Transactions List", class = "text-primary")),br(),
        DT::dataTableOutput("transtable2"),
        printWhiteSpace(),
        tags$em(tags$h3("Transaction Map", class = "text-primary")),br(),
        sidebarLayout(
            sidebarPanel(
                noteTransactionMap()
            ),
            mainPanel(
                leafletOutput("transMap"))
        ),
        printMainAuthority()
        
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
    
    
    # @Truc
    # Function:  output$userInformation 
    # Component: Logic, UI
    # Variable: Local  
    output$userInformation <- DT::renderDataTable({
        df<-UserInformation()
        datatable(
            df[,c("name_on_card", "address", "date_of_birth", "login_username", "login_password", "income")],
            options = list(autoWidth = TRUE,searching = FALSE)
        )
    })
    # End output$userInformation
    
    
    # @Truc
    # Function:  output$cardInformation 
    # Component: Logic, UI
    # Variable: Local  
    output$cardInformation <- DT::renderDataTable({
        df<-UserCards()
        datatable(
            df[,c('card_id','credit_card_number','expiration_date','name_of_card')],
            options = list(autoWidth = TRUE,searching = FALSE)
        )
    })
    # End output$cardInformation 
    
   
    # @Truc
    # Function:  output$transtable2 
    # Component: Logic, UI
    # Variable: Local
    output$transtable2 <- DT::renderDataTable({
        df<-UserTransaction()
        df[,c('Type','Date','Time','Store Name', 'Card','Category','Amount')]
    })
    
    
    # @Truc
    # Function:  output$transMap, function take the user data transaction and
    #            populate the transaction map from user transactions
    # Component: Logic, UI
    # Variable: Local
    output$transMap <- renderLeaflet({
        userLocation <- UserTransaction()
        userLocation <-
            aggregate(Amount ~ Latitude + Longitude + `Store Name`,data = userLocation ,FUN = sum)
            
        leaflet(data = userLocation) %>% addTiles() %>%
            addMarkers( ~ as.numeric(Longitude),~ as.numeric(Latitude), 
                        label = ~ as.character(`Store Name`),popup =  ~ as.character(paste('$ ',Amount)))
    })
}


# @Swetha @Truc
#
# Function: run App will run shiny app in the web browser
# Component: UI
# Variable: Global
runApp(list(ui = ui, server = server), launch.browser = TRUE)