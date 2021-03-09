#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

library(dplyr)
library(DT)
library(ggplot2)

library(plotly)
library(readr)
library(shinythemes)

# import data
UserDataOrg <-
    read_csv(
        "data/Chase2107_Activity_20210306.CSV",
        col_types = cols(`Posting Date` = col_date(format = "%m/%d/%Y"))
    )

UserDataOrg$Type <- NULL

UserDataOrg <-UserDataOrg %>% rename(c(type = Details,date = `Posting Date`,
                                       amount = Amount, balance = Balance, description=Description ))
UserData <- UserDataOrg

UserData$description <- NULL

# Create explicit data frame for modification, and display
Total <- aggregate(select(UserData, -c(type))['balance'], select(UserData, -c(type))['date'], last)

# Main UI
shinyUI(fluidPage(
  
    theme = shinytheme("superhero"),
    
    navbarPage("Personal Expense Analyst",
               tabPanel("About Us"),
               navbarMenu("Setting",
                          tabPanel("Summary"),
                          "----",
                          "Section header",
                          tabPanel("Table")
               )
    ),
    # Application title
    titlePanel("Expense Analyst"),
    
    
    sidebarLayout(
        sidebarPanel(
                conditionalPanel(
                'input.dataset === "User Expense"',
                checkboxGroupInput("show_vars", "Columns To Show:",
                                   names(UserDataOrg), selected = names(UserDataOrg)),
                
                # Add on Feature
                actionButton("add", "Add Transaction"),
                actionButton("remove", "Remove transaction"),
                numericInput("serving", "Number of servings contained", min = 0.01, step = 1, value = 1),
                
            ),
            conditionalPanel(
                'input.dataset === "Analyst"',
              
                #------------------------------------------------------------
                tags$h3("View by Transaction Amount",class="text-info"),
                # Show a plot of the generated distribution
                tags$p("Note: Move the slider to see the frequency of the total balance in your bank account."),
                sliderInput("bins","Number of bins:",
                                         min = 1,max = 100,value = 30),
                tags$br(),tags$br(),
                tags$hr(),
                
                #------------------------------------------------------------
                tags$h3("Total Balance",class="text-info"),
                # Select date range to be plotted
                tags$p("Note: Choose date to see the total balance between a specific time!"),
                dateRangeInput("date1",strong("Date range"),start = "2019-03-06",end = "2021-03-05",
                                 min = "2019-03-06",max = "2021-03-05"),
                tags$br(),tags$br(),
                tags$hr(),
                
                #------------------------------------------------------------
                
                tags$h3("Transaction By Category",class="text-info"),
                
                tags$div(
                  tags$p("Select one of the following option:"),
                  tags$li("DEBIT: debit balances include assets, expenses, and losses..."),
                  tags$li("CREDIT: credit balances include incomes, revenue accounts, and gain accounts..."),
                  tags$li("CHECK: Deposit of check(s)."),
                  tags$li("DSLIP: Deposit slips (check or cash)."),
                  tags$br(),),
                
                # Select type of trend to plot
                selectInput(inputId = "type",label = strong("Type of Transaction"),
                            choices = unique(c('DEBIT', 'CREDIT', 'CHECK', 'DSLIP')), selected = "DEBIT" ),
                
                # Select date range to be plotted
                dateRangeInput("date", strong("Date range"), start = "2019-03-06", end = "2021-03-05",
                               min = "2019-03-06",max = "2021-03-05"),
                
                # Select whether to overlay smooth trend line
                checkboxInput( inputId = "smoother", label = strong("Overlay smooth trend line"),
                               value = FALSE),
                
                # Display only if the smoother is checked
                conditionalPanel(condition = "input.smoother == true",
                                 sliderInput( inputId = "f",label = "Smoother span:",
                                              min = 0.01, max = 1, value = 0.67,step = 0.01,
                                              animate = animationOptions(interval = 100)),
                                 HTML("Higher values give more smoothness.")),
                tags$p("Note:"),
                
                tags$br(),tags$br(),
                tags$hr(),
                #------------------------------------------------------------
            ),
            tags$div(
              tags$p("Support:"),
              tags$li("Truc Huynh business services: 800-242-7338."),
              tags$li("For online technical support, please call us at 1-877-242-7372"),
              tags$li("For help with online banking, please  contact us online"))
          
        ),

        
        mainPanel(
            tabsetPanel(
                id = 'dataset',
                tabPanel("User Expense", DT::dataTableOutput("mytable1")),
                tabPanel("Analyst", 
                         plotOutput("distPlot", height = "300px"),
                         plotOutput("lineplot1", height = "300px"),
                         plotOutput("lineplot"),
                         tags$a(href = "https://github.com/jackyhuynh", "Source: Private Data from Truc"))
            )
        )
        
        
        
    )
))
