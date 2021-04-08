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
if (interactive()) {
    
    ui <- fluidPage(
        sidebarLayout(
            sidebarPanel(
                fileInput("file1", "Choose CSV File",
                          accept = c(
                              "text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv")
                ),
                tags$hr(),
                checkboxInput("header", "Header", TRUE),
                
                # Button
                downloadButton("downloadData", "Download")
            ),
            mainPanel(
                tableOutput("contents")
            )
        )
    )
    
    server <- function(input, output) {
        output$contents <- renderTable({
            # input$file1 will be NULL initially. After the user selects
            # and uploads a file, it will be a data frame with 'name',
            # 'size', 'type', and 'datapath' columns. The 'datapath'
            # column will contain the local filenames where the data can
            # be found.
            inFile <- input$file1
            
            if (is.null(inFile))
                return(NULL)
            
            read.csv(inFile$datapath, header = input$header)
        })
        

        
        output$downloadData <- downloadHandler(
            filename = function() {
                paste(input$file1, ".csv", sep = "")
            },
            content = function(file) {
                write.csv(contents(), file, row.names = FALSE)
            }
        )
    }
    
    shinyApp(ui, server)
}