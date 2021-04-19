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



ui <- dashboardPage(
  dashboardHeader(title = "Financial Freedom", uiOutput("logoutbtn")),
  dashboardSidebar(uiOutput("sidebarpanel")),
  dashboardBody(shinyjs::useShinyjs(), uiOutput("body")),
  skin = "blue"
)



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