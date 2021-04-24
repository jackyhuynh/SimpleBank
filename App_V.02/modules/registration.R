#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
#



library(shiny)
library(shinydashboard)
library(DT)
library(shinyjs)
library(sodium)
library(shinyauthr)
library(odbc)
library(RMySQL)
library(sqldf)
library(DBI)
library(shinyalert)
library(shinyFeedback)
library(ggplot2)


addNewUser <- function(connection, userObject){
  query <- sprintf("insert into user_details(name_on_card, address, user_ssn, date_of_birth, login_username, login_password) values('%s', '%s', '%s', STR_TO_DATE ('%s','%s'), '%s', '%s');", userObject@name, userObject@address, userObject@ssn, userObject@dob, "%m/%d/%Y", userObject@username, userObject@password);
  rs = dbSendStatement(connection, query);
  print(paste("Log: User record inserted success:", dbHasCompleted(rs)));
  return(dbHasCompleted(rs)); 
};

##Create Classes used 
setClass("user", slots=list(userid="numeric", name="character", ssn="numeric", address="character", dob="character", username="character", password="character"));

if (interactive()) {
    fieldsMandatory <-c("Username", "Password","Retype Password", "Mobile Number", " EmailID", "SSN", "CREDITCARD NUMBER","Name On Credit Card","EXPIRY DATE")
    
    labelMandatory <- function(label) {
        tagList(label,span("*", class = "mandatory_star"))}
    
    appCSS <- ".mandatory_star { color: red; }"
    
    # User Registration screen
    uregistration <-
        div(
            id = "uregistration",
            style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
            wellPanel(
              tags$h2("REGISTRATION FORM", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
              box(width=12,
                  
                  tags$h4("User information"),
                  
                  textInput("userName", label = tagList(icon("user"), labelMandatory("Username"))),
                  
                  passwordInput( "passwd",label = tagList(icon("unlock-alt"), labelMandatory("Password"))),
                  
                  passwordInput("rpasswd",label = tagList(icon("unlock-alt"), labelMandatory("Retype Password"))),
                  
                  numericInput("mnumber", value = '', labelMandatory("Mobile Number")),
                  
                  textInput("email",label = tagList(icon("user"), labelMandatory("EmailID"))),
                  
                  numericInput("ssn",labelMandatory("SSN"),value = '',min = 9,max = 9, step = 9),
              ),
                
                

              box(width=12,
                  
                  tags$h4("Card information"),
                  
                  textInput("ccnum",label = tagList(icon("credit-card"), labelMandatory("CREDITCARD NUMBER"))),
                  
                  textInput( "ccname",label = tagList(icon("user"), labelMandatory("Name On Credit Card"))),
                  
                  dateInput("expiry",labelMandatory("EXPIRY DATE"),
                            value = NULL, format = " yyyy-mm-dd ", startview = "month", weekstart = 0,
                            language = "en",width = NULL, autoclose = TRUE, datesdisabled = NULL,daysofweekdisabled = NULL),
                  )
                ),
            
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
                        class = "text-center"))),
            )
        )
    
    
    header <-
        dashboardHeader(title = "User registration", uiOutput("logoutbtn"))
    sidebar <- dashboardSidebar(uiOutput("sidebarpanel"))
    body <-
        dashboardBody(shinyjs::useShinyjs(),
                      shinyjs::inlineCSS(appCSS),
                      uiOutput("body"))
    ui <-
        dashboardPage(header, sidebar, body, skin = "blue", useShinyalert())
    
    server <- function(input, output, session) {
        register = FALSE
        #data <- reactiveValues()
        
        USER <- reactiveValues(register = register)

        
        isValid <- FALSE
        observeEvent(input$register, {
            #    obsC <- observe({
            if (USER$register == FALSE & isValid == FALSE) {
                if (!is.null(input$register)) {
                    if (input$register > 0) {
                        #   req(input$userName)
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
                        
                        if (input$userName == "") {
                            msg1 <- "Please Enter a Valid User Name.\n"
                            print(msg1)
                        }
                        
                        Username <- isolate(input$userName)
                        if (input$passwd == "") {
                            msg2 <- "Please Enter a Valid Password.\n"
                            print(msg2)
                        }
                        Password <- isolate(input$passwd)
                        if (input$rpasswd == "") {
                            msg3 <- "Please Re-Enter a Valid Password.\n"
                            print(msg3)
                        }
                        if (input$rpasswd != Password) {
                            msg4 <- "Passwords not matching.\n"
                            print(msg4)
                        }
                        RetypePassword <- isolate(input$rpasswd)
                        
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
                        

                        # pasmatch  <-
                        #     credentials["passod"][which(credentials$username_id == Username), ]
                        
                        # concatenate two strings using paste function
                        result = paste(msg1, msg2,msg3,msg4, msg5,msg6, msg7,msg8,msg9,sep = "")
                        
                        if (!is.null(result) && nchar(result) > 0) {
                            shinyalert(result, type = "error")
                            print("Something wrong.")
                            isValid <- FALSE
                            return(NULL)
                        }
                        isValid <- TRUE
                        # pasverify <- password_verify(pasmatch, Password)
                        
                        regverify <-
                            register(
                                Username,Password,MobileNumber,EmailID,SSN,CREDICARDNUMBER,NameOnCreditCard,EXPIRYDATE
                            )

                        
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
        
        output$value <- renderText({input$email})
        
        output$logoutbtn <- renderUI({
            req(USER$register)
            tags$li(
                a(icon("fa fa-sign-out"), "Logout",
                  href = "javascript:window.location.reload(true)"),
                class = "dropdown",
                style = "background-color: #eee !important; border: 0;
                    font-weight: bold; margin:5px; padding: 10px;")
        })
        
        output$sidebarpanel <- renderUI({
            if (USER$register == TRUE) {
                sidebarMenu(
                    menuItem("Main Page",tabName = "dashboard", icon = icon("dashboard")),
                    menuItem("Second Page",tabName = "second", icon = icon("th")
                    )
                    
                )
            }
        })
        
        output$body <- renderUI({
            if (USER$register == TRUE) {
                tabItems(
                    # First tab
                    tabItem(
                        tabName = "dashboard",class = "active",
                        fluidRow(box(width = 12, dataTableOutput('results') ))
                    ),
                    
                    # Second tab
                    tabItem(tabName = "second",
                            fluidRow(box(width = 12, dataTableOutput('results2'))))
                )
                
            }
            else { uregistration}
        })
        
        register <- function(username,passwrd,MobileNumber,EmailID,SSN,CREDITCARDNUMBER,CREDITCARDNAME,EXPIRYDATE) {
          
          # Debugging only  
          # print("inside register")
          # print(username)
          # print(passwrd)
          # print(MobileNumber)
          # print(EmailID)
          # print(SSN)
          # print(CREDITCARDNUMBER)
          # print(CREDITCARDNAME)
          # print(EXPIRYDATE)

          isRegistered <- FALSE
          connection <- dbConnect(MySQL(), user = 'root', password = 'Myskhongbiet88', 
                                  dbname = 'credit_card_analysis2', host = 'localhost');
          
          userObj <- new("user", name=CREDITCARDNAME, ssn=SSN, username=username, 
                         password=passwrd, dob="01/21/1975", address="Londn, England");
          
          isRegistered <- addNewUser(connection, userObj);
          
          print(paste("Log: User record inserted success:", isRegistered));

                dbDisconnect(connection)
                return(isRegistered)
      }# End of register function
        
    }
}
runApp(list(ui = ui, server = server), launch.browser = TRUE)
#runApp(launch.browser = TRUE)

