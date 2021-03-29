#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
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
sort(unique(odbcListDrivers()[[1]]))
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
            "Oops! Incorrect username or password!",
            style = "color: red; font-weight: 600;
                                            padding-top: 5px;font-size:16px;",
            class = "text-center"
          )
        )),
        br()
        
      
      )
    )
  )

credentials = data.frame(
  username_id = c("myuser", "myuser1"),
  passod   = sapply(c("mypass", "mypass1"), password_store),
  permission  = c("basic", "advanced"),
  stringsAsFactors = F
)

header <-
  dashboardHeader(title = "Simple Dashboard", uiOutput("logoutbtn"))

sidebar <- dashboardSidebar(uiOutput("sidebarpanel"))
body <- dashboardBody(shinyjs::useShinyjs(), uiOutput("body"))
ui <- dashboardPage(header, sidebar, body, skin = "blue")

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
            validateCredentails(Username, Password)
          
          
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
  
  output$body <- renderUI({
    if (USER$login == TRUE) {
      tabItems(
        # First tab
        tabItem(tabName = "dashboard", class = "active",
                fluidRow(box(
                  width = 12, dataTableOutput('results')
                ))),
        
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
  
  output$results <-  DT::renderDataTable({
    datatable(iris, options = list(autoWidth = TRUE,
                                   searching = FALSE))
  })
  
  output$results2 <-  DT::renderDataTable({
    datatable(mtcars, options = list(autoWidth = TRUE,
                                     searching = FALSE))
  })
  
  validateCredentails <- function(userid, passwrd) {
    print("inside validateCredentails")
    print(userid)
    drv <- dbDriver("MySQL")
    #con <- dbConnect(odbc(), "DSN name")
    isValid <- FALSE
    mydb <-
      dbConnect(
        drv,
        user = 'root',
        password = 'admin',
        dbname = 'creditcard_data_analysis',
        host = 'localhost'
      )
    #SELECT * FROM airports WHERE faa = '", airport_code ,"'
    rs <-
      dbSendQuery(
        mydb,
        paste0(
          "select userid from users where userid='",
          userid ,
          "' and password = '",
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
  
}

runApp(list(ui = ui, server = server), launch.browser = TRUE)