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


createNewUserTransactionTable <- function(username, password){
  connection <- getConnection();
  query <- sprintf("select user_id from user_details where login_username= '%s'
                   and login_password= '%s' and deleted=1;", username, password);
  rs = dbSendQuery(connection, query);
  data = fetch(rs, n= -1);
  if(nrow(data) == 1){
    userId <- head(data, n=1);
    query <- sprintf("create table user_transaction_user_id_%s( transaction_id int not null auto_increment, card_id_fk int, category_id_fk int, locationid_id_fk int, amount double, date_of_transaction varchar(20), time_of_transaction time, transaction_type enum('Credit', 'Debit'), deleted int default 1, primary key (transaction_id), foreign key (card_id_fk) references card_details(card_id), foreign key (category_id_fk) references category(category_id), foreign key (locationid_id_fk) references locations(location_id) )auto_increment=1;", userId);
    rs = dbSendStatement(connection, query);
    dbDisconnect(connection);
  } else{
    print(paste("Log : Not found user:", username));
    dbDisconnect(connection);
    return(0)
  }
}


##ADD NEW USER 

addNewUser <- function(connection, userObject){
  
  query <- sprintf("insert into user_details(name_on_card, address, user_ssn, date_of_birth, login_username, login_password,income) 
                   values('%s', '%s', '%s', '%s', '%s', '%s', '%s');", 
                   userObject@name, userObject@address, userObject@ssn, userObject@dob, userObject@username, userObject@password, userObject@income);
  rs = dbSendStatement(connection, query);
  result<-dbHasCompleted(rs)
  print(paste("Log: User record inserted success:",result ));
  
  # Clear all the result
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(result); 
};


##USER AUTHENTICATION
getUserID <- function(username, password, connection){
  query <- sprintf("select user_id from user_details where login_username= '%s' 
                   and login_password= '%s' and deleted=1;", username, password);
  
  rs = dbSendQuery(connection, query);
  data = fetch(rs, n= -1);  
  dbClearResult(rs)
  dbDisconnect(connection)
  
  if(nrow(data) == 1){
    print(paste("Log: Success found user:", username));
    return(data)
  } else{
    print(paste("Log : Not found user:", username));
    return(0)
  }
}

## Add New Card to the database
addNewCard <- function(connection, cardObject){
  query <- sprintf("insert into card_details(user_id_fk, credit_card_number, expiration_date, name_of_card) 
                   values('%s', '%s','%s' , '%s');", 
                   cardObject@userId, cardObject@cardNumber, cardObject@expirationDate, cardObject@cardName)
  
  rs = dbSendStatement(connection, query);
  result<-dbHasCompleted(rs)
  print(paste("Log: Card inserted success:",result ));
  
  # Clear all the result
  dbClearResult(rs)
  dbDisconnect(connection)
  
  return(result); 
}


##Class for Card
setClass("card", slots=list(cardId="numeric", userId="numeric", cardNumber="numeric", expirationDate="character", cardName="character"))


##Create Classes used 
setClass("user", slots=list(userid="numeric", name="character",  address="character",ssn="numeric", dob="character", username="character", password="character", income="numeric"));

##Only change user, password and host
getConnection <- function(){
  connection = dbConnect(MySQL(), user = 'root', password = 'Myskhongbiet88', dbname = 'credit_card_analysis2',
                         host = 'localhost');
  return(connection);
};

if (interactive()) {
    # fieldsMandatory <-c("Username", "Password","Retype Password", "Mobile Number", " EmailID", "SSN", "CREDITCARD NUMBER","Name On Credit Card","EXPIRY DATE")
    
    labelMandatory <- function(label) {
        tagList(label,span("*", class = "mandatory_star"))}
    
    appCSS <- ".mandatory_star { color: red; }"
    
    # User Registration screen
    uregistration <-
        div(
            id = "uregistration",
            style = "width: 600px; max-width: 100%; margin: 0 auto; padding: 20px;",
            
            box(width = 12,
                tags$h2("REGISTRATION FORM", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
            
                box(width=12,
                  tags$h4("Login information", class = "text-center"),
                  textInput("userName", label = tagList(icon("user"), labelMandatory("Username"))),
                  passwordInput( "passwd",label = tagList(icon("unlock-alt"), labelMandatory("Password"))),
                  passwordInput("rpasswd",label = tagList(icon("unlock-alt"), labelMandatory("Retype Password"))), ),
               
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
    
    
    header <-
        dashboardHeader(title = "User registration", uiOutput("logoutbtn"))
    sidebar <- dashboardSidebar(uiOutput("sidebarpanel"))
    body <-
        dashboardBody(shinyjs::useShinyjs(),
                      shinyjs::inlineCSS(appCSS),
                      uiOutput("body"))
    ui <-dashboardPage(header, sidebar, body, skin = "blue", useShinyalert())
    
    server <- function(input, output, session) {
        register = FALSE
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
                        
                        UserBirthDate <- isolate(input$birthdate)
                          
                        UserAddress <- isolate(input$useradress)
                        
                        UserIncome <- isolate(input$income)
                        

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
                        fluidRow(box(width = 12, dataTableOutput('results') ))),
                    # Second tab
                    tabItem(tabName = "second",
                            fluidRow(box(width = 12, dataTableOutput('results2')))))
                
            }
            else { uregistration}
        })
        
        # This function register user
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
    }
}
runApp(list(ui = ui, server = server), launch.browser = TRUE)
#runApp(launch.browser = TRUE)

