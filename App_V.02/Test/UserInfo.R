library(shiny)

# Only run examples in interactive R sessions
# Get the connection from the database
connection <- getConnection()

value<-getUserID('davis_miles','password123', connection)

# Get the location list
rs <-dbSendQuery(connection,
        paste0("select * from user_details where user_id='",value,"'"))

currentUser <- dbFetch(rs)

dbDisconnect(connection)

#Label mandatory fields
labelMandatory <- function(label) {
  tagList(label,span("*", class = "mandatory_star")
  )}

# UI AND SERVER FOR USER INFO DISPLAY TESTING
#------------------------------------------------------------

ui <- fluidPage(
  
  tags$div(
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
              "fullName",labelMandatory("Full Name"), placeholder = currentUser[[2]],width = '200px'),
            tags$div(),
            textInput(
              "address","Address", placeholder = currentUser[[3]],width = '200px')
          )
        ),
        tags$div(
          splitLayout(
            cellWidths = c("200px","20", "250px"),
            cellArgs = list(style = "vertical-align: top"),
            textInput(
              "fullName","Birthday", placeholder = currentUser[[5]],width = '200px'),
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
              "fullName",labelMandatory("User Name"), placeholder = currentUser[[6]],width = '200px'),
            tags$div(),
            textInput(
              "address",labelMandatory("Password Name"), placeholder = currentUser[[7]],width = '200px')
          ))
      )))


)

server <- function(input, output) {
    entry_form <- function(button_id){}
}

shinyApp(ui, server)
