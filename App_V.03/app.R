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
library(lubridate)  # For date manipulation

library(shinyalert)
library(shinyFeedback)

# @ Truc 
# Source Script to support application UI, and Logic
source("modules/print_display_module.R")

# @ Wrucha
# Source Script to SQL
source("modules/sql_api.R")
source("modules/DataClasses.R")

# @ Swetha
# Source Script to support application UI, Logic on Login Page
source("modules/login_module.R")


# @Swetha
#
# Name: Main login screen
# Function: UI Component for Login Screen
# Component: UI
# Variable: Global



loginpage <-
    div(id = "loginpage",
        
        style = "width: 800px;height:800px; max-width: 100%;max-height: 100%; margin: 0 auto",
        box( width=12,style="margin: 0 auto;",
                 tags$img(src = "https://media.istockphoto.com/vectors/financial-analyst-business-finance-development-and-management-vector-id1139383454?k=6&m=1139383454&s=612x612&w=0&h=eZoUgg34gXVokvsbKLTKoj1ydi96MRKsOPl8LWKQlbo=",
                          style ="width: 600px;height:300px;display: block;margin-left: auto;margin-right: auto;
                          padding-top: 20px;padding-bottom: 15px;"),
             
        div(
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
                    
                    br(),
                    
                    tags$div(
                        splitLayout(
                            cellWidths = c("200px","15", "200px"),
                            cellArgs = list(style = "vertical-align: top"),
                            actionButton( "login","SIGN IN",
                                          style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;"),
                            tags$div(),
                            actionButton("registerButton","REGISTER",
                                         style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;")
                        )
                    ),
                    
                    # Hidden string for user notification
                    shinyjs::hidden(div(
                        id = "nomatch",
                        tags$p(
                            "Incorrect username or password!",
                            style = "color: red; font-weight: 600;
                                            padding-top: 5px;font-size:16px;",
                            class = "text-center"
                        )
                    )),br(),br(),
                    
                    tags$p(
                        "Click forgot password to reset your password!",style="color: red"),
                    tags$div(
                        actionLink("forgotPassword", "FORGOT PASSWORD",
                                   style="color: black; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;")
                    )
                )))))
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








# @Truc
#
# Function: getConnection, Create User data banking Account
# Component: Logic
# Variable: Global
connection<-getConnection()
UserData.Tidy<-geUsertBankTrans(connection)
TotalBalance<-getTotalBalance(UserData.Tidy)


# @Swetha
#
# Function: ui dashboard for the main page
#           Top header, sidebar, and body for the Dashboard
# Component: UI
# Variable: Global
ui <- dashboardPage(
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
    # Validate everytime user login
    login <- FALSE
    id = 1
    register <- FALSE
    isValid <- FALSE
    save <- FALSE
    
    USER <- reactiveValues(login = login,
                           id=id,
                           register=register,
                           save = save)
    
    # @Truc
    # get the transactionlist
    connection<-getConnection()
    TransactionList <- getCategoryList(connection)
    

    # @Truc
    # get The Category Name
    getCategoryIdFromCategoryName <- function(CategoryName)
    {
        for (i in 1:nrow(TransactionList)) {
            if (TransactionList[i, ]$Category == CategoryName)
                return (TransactionList[i, ]$cid) }
        return (0)
    }
    
    
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
                        USER$login <- TRUE # Get User login
                        connection<-getConnection() # get User Connection
                        USER$id <- getUserID(Username, Password, connection) # get User ID
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
    
    
    #load responses_df and make reactive to inputs
    responses_df <- reactive({
        input$submit_edit  #make reactive to
        UserTransaction()
    })
    
    
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
    
    
    # @Truc 
    #
    # Function: get user debit transaction
    # Component: Logic
    # Variable: Local
    UserDebitTransaction<-reactive({
        connection<-getConnection()
        getTransactionWithType(connection,USER$id,"Debit")
    })
    
    
    # @Truc 
    #
    # Function: get user credit transaction
    # Component: Logic
    # Variable: Local
    UserCreditTransaction<-reactive({
        connection<-getConnection()
        getTransactionWithType(connection,USER$id,"Credit")
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
    
    
    # @Swetha @Truc
    #
    # Function: Log out button for Welcome Page
    # Component: UI, part of user Welcome Page UI
    # Variable: Local
    output$sidebarpanel <- renderUI({
        if (USER$login == TRUE) {
            sidebarMenu(
                menuItem("All Transaction",tabName = "dashboard",icon = icon("dashboard")),
                menuItem("Banking Transaction",tabName = "second",icon = icon("university")),
                menuItem("Category Analytic",tabName = "third",icon = icon("chart-pie")),
                menuItem("Cards Analytic",tabName = "fourth",icon = icon("chart-bar")),
                menuItem("User Information",tabName = "fifth",icon = icon("info-circle")),
                menuItem("Help",tabName = "sixth",icon = icon("question-circle")),
                menuItem("Setting",tabName = "seventh",icon = icon("cog"))
                )}
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
        box( width = 12,tags$div(DT::dataTableOutput("userInformationDisplay"))),
        br(),
        tags$em(tags$h3("User Cards Info", class = "text-primary")),
        box(width = 12,tags$div(DT::dataTableOutput("cardInformation"))),
        printMainAuthority()
    )
    
    
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
                    selected = "DEBIT"),
                
                # Select date range to be plotted
                dateRangeInput("date",
                    strong("Date range"),
                    start = min(TotalBalance$date),
                    end = max(TotalBalance$date),
                    min = min(TotalBalance$date),
                    max = max(TotalBalance$date)
                ),
                
                # Select whether to overlay smooth trend line
                checkboxInput(inputId = "smoother",label = strong("Overlay smooth trend line"),
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
        noteTransactionType(),
    )
    
    
    # @Truc
    # Function:  UserBankingUI 
    # Component: UI, Hold all the component of UserBanking UI which is the transaction list
    #             the 3 chart that out put to the User Bankingg Page (3 tabs panel)
    # Variable: Local
    UserBankingUI <- fluidPage(
        tags$em(tags$h3("User Bank Account", class = "text-primary")),
        box(width = 12,
            sidebarLayout(
                sidebarPanel (checkboxGroupInput(
                    "show_trans","Selections:",names(UserData.Tidy),
                    selected = names(UserData.Tidy)),br(),
                    tags$p('Note: Click to select or de-select column views!')),
                mainPanel (DT::dataTableOutput("bankTable")))),
        br(),
        tags$em(tags$h3("Spending & Category Analyzing", class = "text-primary")),
        box(width=12,
            tabsetPanel(
            id = 'bankset',
            balanceFrequencyUI, # balance Frequency UI Component
            totalBalanceUI, # total Balance Overtime
            AnalyzeByCategoty # Analyze by Category with time frame
        )),
        printMainAuthority()
    )
    
    
    # @Truc
    # Function:  CategoryAnalystUI 
    # Component: UI Component that contain the UI and Logic component to create
    #           the Category Analyst UI: included categoryBarPlot, piePlotDebit
    #           and Income VS. Expense Panel
    # Variable: Local
    CategoryAnalystUI<-fluidPage(
        tags$em(tags$h3("Spending Summary by Category", class = "text-primary")),
        box(width = 12,
            tags$p('View up to date Spending Summary by Category:'),
            plotOutput("categoryBarPlot", height = "500px")),
        br(),
        tags$em(tags$h3("Type & Category Analyzing", class = "text-primary")),
        box(width=12,
            tags$p('View up to date Spending Summary by Category and Transaction Type:'),
            plotOutput("piePlotDebit", height = "400px")),
        tags$em(tags$h3("Income vs. Expense", class = "text-primary")),
        box(width=12,
            tags$p('View up to date Spending Summary by Income vs. Expense:'),
            box(width = 6,tags$h3('Total Expense'),verbatimTextOutput("Expense")),
            box(width = 6,tags$h3('Total Income'),verbatimTextOutput("Income")),
            tags$h3('Balance Diffrential'),
            tags$p('View up to date Spending Summary by Income vs. Expense:'),
            verbatimTextOutput("Diffrential"),
            ),
        printMainAuthority()
    )
    

    # @Truc
    # Function:  CardsAnalystUI 
    # Component: UI, Component that contain the whole UI and Logic component that
    #             create the Analyze by Cards Page, include: "AnalyzeByCard" plot
    #             and AnalyzeByCardCategory plot
    # Variable: Local
    CardsAnalystUI<- fluidPage(
        tags$em(tags$h3("Cards Analyzing by Total", class = "text-primary")),
        box(width = 12,
            tags$p('View up to date Spending Summary by Cards:'),
            plotOutput("AnalyzeByCard", height = "180px")),
        box(width=12,tableOutput("DisplayTotalCards")),
        br(),
        tags$em(tags$h3("Cards Analyzing by Category", class = "text-primary")),
        box(width = 12,
            tags$p('View up to date Spending Summary by Cardsand Category:'),
            plotOutput("AnalyzeByCardCategory", height = "400px")),
        printMainAuthority()
    )
    
    
    # @Truc
    # Function:  HelpUI 
    # Component: UI, Component for the Help Page
    # Variable: Local
    HelpUI<-fluidPage(
        tags$em(tags$h3("Help Pages", class = "text-primary")),
        box(width = 12,
            tags$p('Look at the bottom for Help:'),
            printMainAuthority()),
    )
    
    
    # @Truc
    # Function:  SettingUI 
    # Component: UI, Component for the Help Page
    # Variable: Local
    SettingUI<-fluidPage(
        tags$em(tags$h3("Setting Pages", class = "text-primary")),
        box(width = 12,
            tags$p('Setting pages in under maintaince Please come back at another time'),
            printMainAuthority()),
    )
    
    
    # @Truc
    # Function: UI Component for the welcome page
    # Component: UI, Hold majority part of user Welcome Page UI
    #            All Chart for user Analyst
    #            List of transactions
    # Variable: Local
    output$body <- renderUI({
        # Allow user login if suceed
        if (USER$login == TRUE) {
            
            tabItems(
                tabItem(tabName = "dashboard", class = "active", AllTransactionUI), # First tab
                tabItem(tabName = "second",UserBankingUI), # Second tab
                tabItem(tabName = "third", CategoryAnalystUI), # Third tab
                tabItem(tabName = "fourth", CardsAnalystUI), # Fourth tab
                tabItem(tabName = "fifth", UserInformationUI), # Fifth tab
                tabItem(tabName = "sixth", HelpUI),
                tabItem(tabName = "seventh", SettingUI))
        }
        # Call the loginpage again if fail to identify user
        else {
            loginpage
        }
    })
    # End output$body
    
    
    # @Truc
    # Form for data entry
    entry_form <- function(button_id) {
        showModal(modalDialog(div(
            id = ("entry_form"),
            tags$head(tags$style(".modal-dialog{ width:400px}")),
            tags$head(tags$style(
                HTML(".shiny-split-layout > div {overflow: visible}"))),
            fluidPage(fluidRow(
                    textInput("Store",labelMandatory("Store Name"),placeholder = ""),
                    textInput("Amount",labelMandatory("Amount"),placeholder = ""),
                    selectInput("Category",labelMandatory("Category"),multiple = FALSE,
                        choices = TransactionList$Category),
                    actionButton(button_id, "Submit")
                ),easyClose = TRUE))))
    }# End entryform
    
    
    # @Swetha
    # Form for 'Forgot Password'
    observeEvent(input$forgotPassword, priority = 21, showModal(modalDialog(
        div(
            id="forgotPassword_form",
            tags$head(tags$style(".modal-dialog{ width:500px}")),
            tags$head(tags$style(
                HTML(".shiny-split-layout > div {overflow: visible}")))
            ,fluidPage(
                tags$h2("RESET PASSWORD", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
                textInput(
                    "userid",
                    placeholder = "Enter User Id",
                    label = tagList(icon("user"), "User Id")
                ),
                passwordInput(
                    "npasswd",
                    placeholder = "Enter new password",
                    label = tagList(icon("unlock-alt"), "New Password")
                ),
                passwordInput(
                    "rpasswd",
                    placeholder = "Retype Password",
                    label = tagList(icon("unlock-alt"), "Retype Password")
                ),
                br(),
                div(
                    style = "text-align: center;",
                    useShinyalert(),
                    actionButton("save","SAVE",
                                 style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;"
                    ),br(),
                    
                    shinyjs::hidden(div(
                        id = "nomatch",
                        tags$p(
                            "Password update failed.Please enter valid username and try again!",
                            style = "color: red; font-weight: 600;
                                            padding-top: 5px;font-size:16px;",
                            class = "text-center"
                        ),)),
                )
            ),easyClose = TRUE
            
        )
    )))
    
    
    # @Swetha
    # Function: observeEvent for the save button
    # Component: Logic, validate and verify user info before add user to the database
    #             Support the Forgot Password Component
    # Variable: Local
    observeEvent(input$save, {
        if (USER$save == FALSE & isValid == FALSE) {
            if (!is.null(input$save)) {
                if (input$save > 0) {
                    msg1 <- ""
                    msg2 <- ""
                    msg3 <- ""
                    msg4 <- ""
                    
                    isValid <- TRUE
                    
                    if (input$userid == "") {
                        msg1 <- "Please Enter a Valid User Id.\n"
                        print(msg1)
                    }
                    userid <- isolate(input$userid)
                    
                    
                    if (input$npasswd == "") {
                        msg2 <- "Please Enter a Valid Password.\n"
                        print(msg2)
                    }
                    npasswd <- isolate(input$npasswd)
                    
                    if (input$rpasswd == "") {
                        msg3 <- "Please Re-Enter a Valid Password.\n"
                        print(msg3)
                    }
                    rpasswd <- isolate(input$rpasswd)
                    
                    if (input$rpasswd != npasswd) {
                        msg4 <- "Passwords not matching.\n"
                        print(msg4)
                    }
                    # concatenate two strings using paste function
                    result = paste(msg1,
                                   msg2,
                                   msg3,
                                   msg4,
                                   sep = "")
                    if (!is.null(result) && nchar(result) > 0) {
                        shinyalert(result, type = "error")
                        print("Something wrong.")
                        isValid <- FALSE
                        result <- ""
                        return(NULL)
                    }
                    isValid <- TRUE
                    pswdUpdated <- updatePassword(userid, npasswd)
                    
                    if (pswdUpdated) {
                        USER$save <- TRUE
                        
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
    
    
    
    # @Swetha
    # Function: updatePassword for the login page
    # Component: Logic, validate and verify update user password
    # Variable: Local
    updatePassword <- function(userid, npasswrd) {
        print("inside updatePassword")
        print(npasswrd)
        drv <- dbDriver("MySQL")
        isUpdated <- 0
        mydb <- getConnection()
        isUpdated <- updateUserDetails(mydb, userid, npasswrd)
        
        
        if (isUpdated >= 1) {
            shinyalert("Password Updated Successfully!!")
            isValid <- TRUE
        }
        else {
            print("Password Update Failed")
            isValid <- FALSE
        }
        
        return(isValid)
    }
    
    
    # @Swetha
    ##UPDATE EXISTING USER
    updateUserDetails <- function(connection, userid, npasswrd) {
        ##Update user_details
        query <-
            sprintf("update user_details set login_password='%s' where login_username='%s'",
                npasswrd,userid)
        
        rs = dbSendStatement(connection, query)
        isSaved <- (dbGetRowsAffected(rs))
        print(paste("Log: User record updated success:", isSaved))
        dbClearResult(rs)
        dbDisconnect(connection)
        return(isSaved)
    }
    
    
    
    # @Swetha @Truc
    # Form for User Registration
    # Function: observeEvent for the registerButton button
    # Component: UI Component for validate and verify user info before add user to the database
    #             Support the Add New User Component/Registration Page
    # Variable: Local
    observeEvent(input$registerButton, priority = 20,showModal(modalDialog(div(
        id = ("register_form"),
        tags$head(tags$style(".modal-dialog{ width:800px}")),
        tags$head(tags$style(
            HTML(".shiny-split-layout > div {overflow: visible}")))
        ,fluidPage(
            div(
                id = "uregistration",
                style = "width: 600px; max-width: 100%; margin: 0 auto; padding: 20px;",
                
                box(width = 12,
                    tags$h2("NEW USER REGISTRATION FORM", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
                    
                    box(width=12,
                        tags$h4("Login information", class = "text-center"),
                        textInput("registerUserName", label = tagList(icon("user"), labelMandatory("Username"))),
                        passwordInput( "registerPassword",label = tagList(icon("unlock-alt"), labelMandatory("Password"))),
                        passwordInput("rregisterPassword",label = tagList(icon("unlock-alt"), labelMandatory("Retype Password"))), ),
                    
                    box(width=12,
                        tags$h4("Account information", class = "text-center"),
                        numericInput("mnumber", value = '', labelMandatory("Mobile Number")),
                        textInput("email",label = tagList(icon("user"), labelMandatory("EmailID"))),
                        dateInput("birthdate",labelMandatory("Date of Birth"),
                                  value = NULL, format = " yyyy-mm-dd ", startview = "month", weekstart = 0,
                                  language = "en",width = NULL, autoclose = TRUE, datesdisabled = NULL,daysofweekdisabled = NULL),
                        numericInput("ssn",labelMandatory("SSN"),value = '',min = 9,max = 9, step = 9),
                        numericInput("income",labelMandatory("Monthly Income"),value = '',min = 9,max = 9, step = 9),
                        textInput("useradress", labelMandatory("Full Address"))),
                    
                    box(width=12,
                        tags$h4("Credit Card information",class = "text-center"),
                        textInput("ccnum",label = tagList(icon("credit-card"), labelMandatory("CREDIT CARD NUMBER"))),
                        textInput( "ccname",label = tagList(icon("user"), labelMandatory("Name On Credit Card"))),
                        dateInput("expiry",labelMandatory("EXPIRATION DATE"),
                                  value = NULL, format = " yyyy-mm-dd ", startview = "month", weekstart = 0,
                                  language = "en",width = NULL, autoclose = TRUE, datesdisabled = NULL,daysofweekdisabled = NULL),
                    )),
                
                div(style = "text-align: center;",
                    useShinyalert(),
                    # Set up shinyalert
                    actionButton("register","REGISTER",
                                 style = "color: white; background-color:#3c8dbc;
                         padding: 10px 15px; width: 150px; cursor: pointer;
                         font-size: 18px; font-weight: 600;"
                    ),
                    shinyjs::hidden(div(id = "nomatch",
                                        tags$p("Registration Failed!",
                                               style = "color: red; font-weight: 600;
                                    padding-top: 5px;font-size:16px;",
                                               class = "text-center")))))
        ),easyClose = TRUE
    ))))
    
    
    # @Swetha @Truc
    # Form for User Registration
    # Function: observeEvent for the register button
    # Component: Logic validation and verify user info before add user to the database
    #             Support the Add New User Component/Registration Page
    # Variable: Local
    observeEvent(input$register, {
        #    obsC <- observe({
        if (USER$register == FALSE & isValid == FALSE) {
            if (!is.null(input$register)) {
                if (input$register > 0) {
                    
                    msg0 <- ""
                    msg1 <- ""
                    msg2 <- ""
                    msg3 <- ""
                    msg4 <- ""
                    msg5 <- ""
                    msg6 <- ""
                    msg7 <- ""
                    msg8 <- ""
                    msg9 <- ""
                    
                    isValid <- TRUE
                    
                    connection<-getConnection()
                    
                    if (checkUserIDExist(input$registerUserName,connection) == TRUE) {
                        msg0 <- "Username is already exist.\n"
                        print(msg0)
                    }
                    
                    if (input$registerUserName == "") {
                        msg1 <- "Please Enter a Valid User Name.\n"
                        print(msg1)
                    }
                    
                    Username <- isolate(input$registerUserName)
                    if (input$registerPassword == "") {
                        msg2 <- "Please Enter a Valid Password.\n"
                        print(msg2)
                    }
                    Password <- isolate(input$registerPassword)
                    if (input$rregisterPassword == "") {
                        msg3 <- "Please Re-Enter a Valid Password.\n"
                        print(msg3)
                    }
                    if (input$rregisterPassword != Password) {
                        msg4 <- "Passwords not matching.\n"
                        print(msg4)
                    }
                    RetypePassword <- isolate(input$rregisterPassword)
                    
                    NameOnCreditCard <- isolate(input$ccname)
                    if (input$ccname == "") {
                        msg9 <- "Please enter Card holder's Name.\n"
                        print(msg9)
                    }
                    
                    
                    EmailID <- isolate(input$email)
                    emailregex <- "^[A-Za-z0-9+_.-]+@(.+)$"
                    if (!grepl(emailregex, EmailID)) {
                        msg6 <- "Please enter a valid EmailID#.\n"
                        print(msg6)
                    }
                    
                    SSN <- isolate(input$ssn)
                    ssnregex <-
                        "^\\d{9}$"
                    # without dashes in between
                    #   ssnregex <- "^\\d{3}-\\d{2}-\\d{4}$"; # with dashes in between
                    if (!grepl(ssnregex, SSN)) {
                        msg7 <- "Please enter a valid SSN#.\n"
                        print(msg7)
                    }
                    
                    MobileNumber <- isolate(input$mnumber)
                    phoneregex <-
                        "^\\s*(\\+\\s*1(-?|\\s+))*[0-9]{3}\\s*-?\\s*[0-9]{3}\\s*-?\\s*[0-9]{4}$"
                    if (!grepl(phoneregex, MobileNumber)) {
                        msg5 <- "Please enter a valid Phone#.\n"
                        print(msg5)
                    }
                    
                    CREDICARDNUMBER <- isolate(input$ccnum)
                    ccnregex <-
                        "^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14})$" ##For visa CC
                    if (!grepl(ccnregex, CREDICARDNUMBER)) {
                        msg8 <- "Please enter a valid Credit Card#.\n"
                        print(msg8)
                    }
                    
                    EXPIRYDATE <- isolate(input$expiry)
                    
                    UserBirthDate <- isolate(input$birthdate)
                    
                    UserAddress <- isolate(input$useradress)
                    
                    UserIncome <- isolate(input$income)
                    
                    # concatenate two strings using paste function
                    result = paste(msg0,msg1, msg2,msg3,msg4, msg5,msg6, msg7,msg8,msg9,sep = "")
                    
                    if (!is.null(result) && nchar(result) > 0) {
                        shinyalert(result, type = "error")
                        print("Something wrong.")
                        isValid <- FALSE
                        return(NULL)
                    }
                    
                    isValid <- TRUE
                    
                    
                    regverify <-
                        register(
                            Username,Password,MobileNumber,EmailID,SSN,CREDICARDNUMBER,
                            NameOnCreditCard,EXPIRYDATE,UserBirthDate, UserAddress, UserIncome)
                    
                    
                    if (regverify) {
                        USER$register <- TRUE
                        print("User Registered Successfully!!")
                        
                    } else {
                        shinyjs::toggle(
                            id = "nomatch",anim = TRUE, time = 1,animType = "fade"
                        )
                        shinyjs::delay(3000,
                                       shinyjs::toggle(
                                           id = "nomatch",anim = TRUE,time = 1,animType = "fade"))
                    }
                }
            }
        }
    })
    
    
    # @Swetha
    # Function: This function register user
    # Component: Logic, insert new user to the database
    # Variable: Local
    register <- function(username,passwrd,MobileNumber,EmailID,SSN,CREDITCARDNUMBER,
                         CREDITCARDNAME,EXPIRYDATE,UserBirthDate, UserAddress, UserIncome) {
        
        isRegistered <- FALSE
        connection <- getConnection()
        
        userObj <- new("user", name=CREDITCARDNAME, ssn=SSN, username=username, 
                       password=passwrd, dob=as.character(UserBirthDate), address=UserAddress, income=as.numeric(UserIncome));
        
        isRegistered <- addNewUser(connection, userObj);
        
        connection <- getConnection() # Create new connection
        cardObj<- new("card", userId=as.numeric(getUserID(username,passwrd,connection)), cardNumber=as.numeric(CREDITCARDNUMBER), 
                      expirationDate=as.character(EXPIRYDATE), cardName=CREDITCARDNAME)
        
        connection <- getConnection() # Create new connection
        CardRegistered <- addNewCard(connection,cardObj)
        createNewUserTransactionTable(username,passwrd)
        return(isRegistered&&CardRegistered)
    }# End of register function
    
    
    
    # @Swetha
    # Function: This function enable user to edit the transaction Category
    # Component: Logic, observe the user click and transfer choosen data to the new form
    # Variable: Local
    observeEvent(input$edit_button, priority = 20, {
        SQL_df <- UserTransaction()
        showModal(if (length(input$transtable2_rows_selected) > 1) {
            modalDialog(title = "Warning",
                        paste("Please select only one row."),
                        easyClose = TRUE)
        } else if (length(input$transtable2_rows_selected) < 1) {
            modalDialog(title = "Warning",
                        paste("Please select a row."),
                        easyClose = TRUE)
        })
        if (length(input$transtable2_rows_selected) == 1) {
            entry_form("submit_edit")
            updateTextInput(session, "Store", value = SQL_df[input$transtable2_rows_selected,'Store Name'])
            updateTextInput(session, "Amount", value = paste('$ ',as.character(SQL_df[input$transtable2_rows_selected,"Amount"])))
            updateTextAreaInput(session, "Category", value = SQL_df[input$transtable2_rows_selected, "Category"])
        }
    })
    
    
    # @Truc
    # Function:  AllTransactionUI 
    # Component: UI, where the regular user interact with data and UI
    # Variable: Local
    AllTransactionUI <- fluidPage(
        # Add CSS UI theme, can easily change theme by change 
        # the theme name inside shinytheme()
        theme = shinytheme("flatly"),
        tags$em(tags$h3("Transactions List", class = "text-primary")),
        
        box(width=12,
            actionButton("edit_button", "Edit Category", icon("edit"))),
            
        tags$br(),
        box(width=12, DT::dataTableOutput("transtable2")),
        

        tags$em(tags$h3("Transaction Map", class = "text-primary")),
        box(width=12,sidebarLayout(
            sidebarPanel( noteTransactionMap()),
            mainPanel(leafletOutput("transMap")))),
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
            
            if (nrow(chunk) == 1) {isValid <- TRUE}
            else {isValid <- FALSE}
        }
        
        # Clear the connection and stop the application
        dbClearResult(rs)
        dbDisconnect(connection)
        return(isValid)
    }
    # End of validateCredential function
    
    ######################################################    
    # @ SET OF USER INFORMATION DISPLAY (USER INFO PANEL)
    ######################################################    
    
    # @Truc
    # Function:  output$userInformation 
    # Component: Logic, UI
    # Variable: Local  
    output$userInformationDisplay <- DT::renderDataTable({
        df<-UserInformation()
        datatable(
            df[,c("name_on_card", "address", "date_of_birth", "login_username", "login_password", "income")],
            options = list(autoWidth = TRUE,searching = FALSE))
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
    
    
    ######################################################
    # @ SET OF TRANSACTION DISPLAY (ALL TRANSACTION PANEL)
    ######################################################
   
    
    # @Truc
    # Function:  save form data into data_frame format
    # Component: Logic form data
    # Variable: Local  
    formData <- reactive({
        formData <- data.frame(
            row_id = UUIDgenerate(),
            Store = input$`Store Name`,
            Amount =  input$Amount,
            Category = input$Category,
            stringsAsFactors = FALSE
        )
        return(formData)
    })
    
    
    # @Truc
    # Function:  observeEvent submit button
    # Component: Logic, Clear the entry form
    # Variable: Local  
    observeEvent(input$submit, priority = 20, {
        appendData(formData())
        shinyjs::reset("entry_form")
        removeModal()
    })
    
    
    
    # @Truc
    # Function:  obsrve register button
    # Component: Logic, Clear the register form
    # Variable: Local 
    observeEvent(input$register, priority = 20, {
        shinyjs::reset("register_form")
        removeModal()
    })
    
    
    observeEvent(input$submit_edit, priority = 20, {
        row_selection <-input$transtable2_row_last_clicked
        categoryId<-as.numeric(getCategoryIdFromCategoryName((input$Category)))
        connection<-getConnection()
        UpdateCategoryForTransaction(as.numeric(USER$id), categoryId, row_selection, connection)
        removeModal()
    })
    
    

    # @Truc
    # Function:  output$transtable2 
    # Component: Logic, UI
    # Variable: Local
    output$transtable2 <- DT::renderDataTable({
        df<-responses_df()
        datatable(df[,c('Type','Date','Time','Store Name', 'Card','Category','Amount')],
                  selection = 'single')
        
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
    
    
    ###########################################
    # @ SET OF LOGIC FOR CHECKING ACCOUNT PANEL
    ###########################################
    
    
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
        validate(need(!is.na(input$date1[1]) &!is.na(input$date1[2]),
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
    # End output$lineplot1Info
    
    
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
        plot(x = selected_User()$date,y = selected_User()$amount,
            type = "o",xlab = "Date",ylab = "Amount",col = color,fg = color,
            col.lab = color,col.axis = color)
        # Display only if smoother is checked
        if (input$smoother) {
            smooth_curve <-lowess(
                    x = as.numeric(selected_User()$date),
                    y = selected_User()$amount,
                    f = input$f)
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
    
    
    ###########################################
    #@ SET OF LOGIC FOR CATEGORY ANALYST PANEL
    ###########################################
    
    # @Truc
    # Function:  output$categoryBarPlot
    # Component: Logic, create CATEGORY BAR PLOT
    # Variable: Local 
    output$categoryBarPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        AllTransaction <- aggregate(Amount~Category+Type, data=UserTransaction(), FUN=sum)
        
        ggplot(AllTransaction, aes(x = Category, y= Amount, fill = Type), xlab="Category") +
            geom_bar(stat="identity", width=.5, position = "dodge")  +
            theme_bw() +
            ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1),
                           panel.border = element_blank(), panel.grid.major = element_blank(),
                           panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) 
    })
    # End output$categoryBarPlot
    
    
    # @Truc
    # Function:  output$piePlotDebit
    # Component: Logic, create CATEGORY & Type Pie Plot
    # Variable: Local
    output$piePlotDebit <- renderPlot({
        
        # Prepare Debit data and summary
        debitTrans<-UserDebitTransaction()
        debitTrans <- aggregate(Amount~Category, data=debitTrans, FUN=sum)
        debitTrans<- debitTrans[order(-debitTrans$Amount),]
        
        # Prepare Credit data and summary
        creditTrans<-UserCreditTransaction()
        creditTrans <- aggregate(Amount~Category, data=creditTrans, FUN=sum)
        creditTrans<- creditTrans[order(-creditTrans$Amount),]
        
        old.par <- par(mfrow=c(1, 2))
        pie(
            debitTrans$Amount, edges = 200, radius = 1,clockwise = TRUE,
            # IMPORTANT
            angle = 45, col = viridis::viridis_pal(option = "magma", direction = -1)(length(debitTrans$Amount)),
            labels = head(scales::percent(as.numeric(debitTrans$Amount/sum(debitTrans$Amount))),-1),
            # NEVER DISPLAY OVERLAPPING LABELS
            cex = 0.7, border = "white",main="Debit Transactions"
        )
        legend(
            1.5,.7,debitTrans$Category,
            cex = 1,
            fill = viridis::viridis_pal(option = "magma", direction = -1)(length(debitTrans$Amount))
        )
        pie(
            creditTrans$Amount, edges = 200, radius = 1,clockwise = TRUE,
            # IMPORTANT
            angle = 45, col = viridis::viridis_pal(option = "magma", direction = -1)(length(creditTrans$Amount)),
            labels = head(scales::percent(as.numeric(creditTrans$Amount/sum(creditTrans$Amount))),-1),
            # NEVER DISPLAY OVERLAPPING LABELS
            cex = 0.7, border = "white",main="Credit Transactions"
        )
        legend(
            1.5,.7,creditTrans$Category,
            cex = 1,
            fill = viridis::viridis_pal(option = "magma", direction = -1)(length(creditTrans$Amount))
        )
        par(old.par)
    })
    # End output$piePlotDebit
    
    
    # @Truc
    # Function:  output$Expense
    # Component: Logic, return the sum of user expense
    # Variable: Local
    output$Expense<-renderText({
        paste0("Amount = $ ", round(as.numeric(sum(UserTransaction()$Amount)),2),
               ", From ",  min(UserTransaction()$Date),
               " To ",max(UserTransaction()$Date))})
    
    
    # @Truc
    # Function:  output$Income
    # Component: Logic, return the sum of user income
    # Variable: Local
    output$Income<-renderText({
        Income<- UserInformation()$income*(interval(min(UserTransaction()$Date),max(UserTransaction()$Date))%/% months(1))
        paste0("Amount = $ ", round(as.numeric(Income),2),
               ", From ",  min(UserTransaction()$Date),
               " To ",max(UserTransaction()$Date))
        })
    
    
    # @Truc
    # Function:  output$piePlotDebit
    # Component: Logic, return the different between Income and expense.
    # Variable: Local
    output$Diffrential<-renderText({
        # User Information
        Income<- as.numeric(UserInformation()$income*(interval(min(UserTransaction()$Date),max(UserTransaction()$Date))%/% months(1)))
        Expense<-as.numeric(sum(UserTransaction()$Amount))
        paste0("Amount = $ ", round(as.numeric(Income-Expense),2),
               ", From ",  min(UserTransaction()$Date),
               " To ",max(UserTransaction()$Date))
    })
    
    
    #######################################
    #@ SET OF LOGIC FOR CARDS ANALYST PANEL
    #######################################
    
    
    # @Truc
    # Function:  output$DisplayTotalCards
    # Component: Logic, the list of user cards.
    # Variable: Local
    output$DisplayTotalCards<-renderTable({
        UserCards <- aggregate(Amount~Card,data=UserTransaction(), FUN=sum)
    })
    
    
    # @Truc
    # Function:  output$AnalyzeByCardCategory
    # Component: Logic, dis play each user cards in each charts.
    # Variable: Local
    output$AnalyzeByCardCategory<-renderPlot({
        SpendingByCard <- aggregate(Amount ~ Category + Card ,data = UserTransaction() ,FUN = sum)
        SpendingByCard$Card<-as.factor(SpendingByCard$Card)
        ggplot(SpendingByCard, aes(x=Category, y=Amount, fill=Category)) + 
            geom_bar(stat="identity") +
            theme_bw() +
            ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1),
                           panel.border = element_blank(), panel.grid.major = element_blank(),
                           panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
            facet_grid(~ Card)
    })
    
    
    # @Truc
    # Function:  output$AnalyzeByCard
    # Component: Logic, create The chart with all the card comparison 
    # Variable: Local
    output$AnalyzeByCard<-renderPlot({
        UserCards <- aggregate(Amount~Card,data=UserTransaction(), FUN=sum)
        ggplot(UserCards, aes(y=Card, x=Amount, fill=Card)) + 
            geom_bar(stat='identity',position = "stack") +
            theme_bw() +
            ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1),
                           panel.border = element_blank(), panel.grid.major = element_blank(),
                           panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) 
    })
}


# @Swetha @Truc
#
# Function: run App will run shiny app in the web browser
# Component: UI
# Variable: Global
runApp(list(ui = ui, server = server), launch.browser = TRUE)
