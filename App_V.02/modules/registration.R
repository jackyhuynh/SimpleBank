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


if (interactive()) {
    fieldsMandatory <-
        c(
            "Username",
            "Password",
            "Retype Password",
            "Mobile Number",
            " EmailID",
            "SSN",
            "CREDITCARD NUMBER",
            "Name On Credit Card",
            "EXPIRY DATE"
        )
    
    labelMandatory <- function(label) {
        tagList(label,
                span("*", class = "mandatory_star"))
    }
    
    appCSS <- ".mandatory_star { color: red; }"
    
    # User Registration screen
    uregistration <-
        div(
            id = "uregistration",
            style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
            wellPanel(
                tags$h2("REGISTRATION FORM", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
                #textInput("name", labelMandatory("Name"), "")
                textInput(
                    "userName",
                    placeholder = "Username",
                    value="username",
                    label = tagList(icon("user"), labelMandatory("Username"))
                    
                ),
                passwordInput(
                    "passwd",
                    placeholder = "Password",
                    value="pass1",
                    label = tagList(icon("unlock-alt"), labelMandatory("Password"))
                ),
                passwordInput(
                    "rpasswd",
                    placeholder = "Retype Password",
                    value="pass1",
                    label = tagList(icon("unlock-alt"), labelMandatory("Retype Password"))
                ),
                numericInput("mnumber", value = '3120690807', labelMandatory("Mobile Number")),
                textInput(
                    "email",
                    placeholder = "email",
                    value="vgs_Raju@rediffmail.com",
                    label = tagList(icon("user"), labelMandatory("EmailID"))
                ),
                # verbatimTextOutput("value"),
                numericInput(
                    "ssn",
                    labelMandatory("SSN"),
                    value = '312069087',
                    min = 9,
                    max = 9,
                    step = 9
                ),
                textInput(
                    "ccnum",
                    placeholder = "CreditCardNumber",
                    value = '4312069087312069',
                    label = tagList(icon("credit-card"), labelMandatory("CREDITCARD NUMBER"))
                ),
                #   numericInput("ccnum","CREDITCARD NUMBER",value = 0,min = 16,max=16),
                textInput(
                    "ccname",
                    placeholder = "CCNAME",
                    value = 'Name onthe Card',
                    label = tagList(icon("user"), labelMandatory("Name On Credit Card"))
                ),
                dateInput(
                    "expiry",
                    labelMandatory("EXPIRY DATE"),
                    value = NULL,
                    format = " yyyy-mm-dd ",
                    startview = "month",
                    weekstart = 0,
                    language = "en",
                    width = NULL,
                    autoclose = TRUE,
                    datesdisabled = NULL,
                    daysofweekdisabled = NULL
                ),
                
                
            ),
            # div (class="form-body",
            # Card Number
            #    input (type ="text", class="card-number", placeholder="Card Number")),
            
            div(
                style = "text-align: center;",
                useShinyalert(),
                # Set up shinyalert
                actionButton(
                    "register",
                    "REGISTER",
                    style = "color: white; background-color:#3c8dbc;
                         padding: 10px 15px; width: 150px; cursor: pointer;
                         font-size: 18px; font-weight: 600;"
                ),
                shinyjs::hidden(div(
                    id = "nomatch",
                    tags$p(
                        "Registration Failed!",
                        style = "color: red; font-weight: 600;
                                    padding-top: 5px;font-size:16px;",
                        class = "text-center"
                    )
                )),
                #  plotOutput('plot')
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
        data <- reactiveValues()
        #values <- reactiveValues(A=1)
        USER <- reactiveValues(register = register)
       # validFiles = c("registration.R")
        
        # obsB <- observe({
        #     # check if all mandatory fields have a value
        #     mandatoryFilled <-
        #         vapply(fieldsMandatory,
        #                function(x) {
        #                    !is.null(input[[x]]) && input[[x]] != ""
        #                },
        #                logical(1))
        #     mandatoryFilled <- all(mandatoryFilled)
        #
        #     # enable/disable the register button
        #     shinyjs::toggleState(id = "register", condition = mandatoryFilled)
        # })
        
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
                        
                        # if(lngth(which(credentials$username_id==Username))==1) {
                        pasmatch  <-
                            credentials["passod"][which(credentials$username_id == Username), ]
                        # concatenate two strings using paste function
                        result = paste(msg1,
                                       msg2,
                                       msg3,
                                       msg4,
                                       msg5,
                                       msg6,
                                       msg7,
                                       msg8,
                                       msg9,
                                       sep = "")
                        
                        if (!is.null(result) && nchar(result) > 0) {
                            shinyalert(result,
                                       type = "error")
                            print("Something wrong.")
                            isValid <- FALSE
                            return(NULL)
                        }
                        isValid <- TRUE
                        # pasverify <- password_verify(pasmatch, Password)
                        regverify <-
                            register(
                                Username,
                                Password,
                                MobileNumber,
                                EmailID,
                                SSN,
                                CREDICARDNUMBER,
                                NameOnCreditCard,
                                EXPIRYDATE
                            )
                        # regverify <- TRUE
                        if (regverify) {
                            USER$register <- TRUE
                            print("User Registered Successfully!!")
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
        output$value <- renderText({
            input$email
        })
        output$logoutbtn <- renderUI({
            req(USER$register)
            tags$li(
                a(icon("fa fa-sign-out"), "Logout",
                  href = "javascript:window.location.reload(true)"),
                class = "dropdown",
                style = "background-color: #eee !important; border: 0;
                    font-weight: bold; margin:5px; padding: 10px;"
            )
        })
        
        output$sidebarpanel <- renderUI({
            if (USER$register == TRUE) {
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
        
        output$body <- renderUI({
            if (USER$register == TRUE) {
                tabItems(
                    # First tab
                    tabItem(
                        tabName = "dashboard",
                        class = "active",
                        fluidRow(box(
                            width = 12, dataTableOutput('results')
                        ))
                    ),
                    
                    # Second tab
                    tabItem(tabName = "second",
                            fluidRow(
                                box(width = 12, dataTableOutput('results2'))
                            ))
                )
                
            }
            else {
                uregistration
            }
        })
        #
        # output$results <-  DT::renderDataTable({
        #     datatable(iris, options = list(autoWidth = TRUE,
        #                                    searching = FALSE))
        # })
        #
        # output$results2 <-  DT::renderDataTable({
        #     datatable(mtcars,
        #               options = list(autoWidth = TRUE,
        #                              searching = FALSE))
        # })
        
        register <-
            function(username,
                     passwrd,
                     MobileNumber,
                     EmailID,
                     SSN,
                     CREDITCARDNUMBER,
                     CREDITCARDNAME,
                     EXPIRYDATE) {
                print("inside register")
                print(username)
                print(passwrd)
                print(MobileNumber)
                print(EmailID)
                print(SSN)
                print(CREDITCARDNUMBER)
                print(CREDITCARDNAME)
                print(EXPIRYDATE)
                drv <- dbDriver("MySQL")
                isRegistered <- FALSE
                connection <-
                  dbConnect(MySQL(), user = 'root', password = 'Myskhongbiet88', dbname = 'credit_card_analysis2',
                            host = 'localhost');
                print(connection)
                # rs = dbSendStatement(connection, query);
                # print(paste("Log: User record inserted success:", dbHasCompleted(rs)));
                # return(dbHasCompleted(rs)); 
                rs =   dbSendStatement(
                    connection,
                    paste0(
                        "insert INTO USERS_ (USERID,PASSWORD,CREATED_DATE,UPDATED_DATE,SSN,CREDITCARD_NUM,EMAILID,NAME_ON_CC,MOBILENUM,EXPIRY_DATE)
 values('",
                        username ,
                        "','",
                        passwrd,
                        "',CURDATE(),CURDATE(),'",
                        SSN,
                        "','",
                        CREDITCARDNUMBER,
                        "','",
                        EmailID,
                        "','",
                        CREDITCARDNAME,
                        "','",
                        MobileNumber,
                        "','",
                        EXPIRYDATE,
                        "')"
                    )
                )
                isRegistered <- (dbHasCompleted(rs));
                print(paste("Log: User record inserted success:", isRegistered));
             #   print(data)
                dbDisconnect(connection)
                return(isRegistered)
            }
        # End of register function
        
    }
}
runApp(list(ui = ui, server = server), launch.browser = TRUE)
#runApp(launch.browser = TRUE)

