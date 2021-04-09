#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

## Only run examples in interactive R sessions
###Get the connection from the database
connection <- getConnection();
# Get the location list
rs <-
    dbSendQuery(
        connection,
        paste0(
            "select * from user_details where user_id='",
            value ,"'"
        )
    )

currentUser <- dbFetch(rs)

dbDisconnect(connection)

#Label mandatory fields
labelMandatory <- function(label) {
    tagList(label,span("*", class = "mandatory_star")
    )}

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
                )
            ),
        )
    )
)
)
    
server <- function(input, output) {}
    
shinyApp(ui, server)