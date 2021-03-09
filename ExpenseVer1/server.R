#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # choose columns to display
    output$mytable1 <- DT::renderDataTable({
        DT::datatable(UserDataOrg[, input$show_vars, drop = FALSE])
    })
    
    # sorted columns are colored now because CSS are attached to them
    output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- Total[,2]
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      title('View by Transaction Amount')
      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'azure3', border = 'white', xlab = "Balance",main = paste('View by Transaction Amount'),)
    })
    
    # Validate the date before plot
    selected_User1 <- reactive({
      req(input$date1)
      validate(need(!is.na(input$date1[1]) & !is.na(input$date1[2]),"Error: Please provide both a start and an end date."))
      validate(need(input$date1[1] < input$date1[2],"Error: Start date should be earlier than end date."))
      Total %>% filter(date > (input$date1[1]) & date < (input$date1[2]))
    })
    
    # Plot the total balance
    output$lineplot1 <- renderPlot({
      color = "azure4"
      par(mar = c(4, 4, 1, 1))
      plot(x = selected_User1()$date, y = selected_User1()$balance, type = "o",
           xlab = "Date", ylab = "Total Balance",col = color, fg = color, col.lab = color, col.axis = color
           ,main = paste('Total Balance'))
      smooth_curve <- lowess(x = as.numeric(selected_User1()$date), y = selected_User1()$balance)
      lines(smooth_curve, col = "#E6553A", lwd = 3)
      
    })
    
    # Subset data, validate the input date to make sure user enter the valid date
    selected_User <- reactive({
      req(input$date)
      
      validate(need(!is.na(input$date[1]) & !is.na(input$date[2]), "Error: Please provide both a start and an end date."))
      
      validate(need(input$date[1] < input$date[2], "Error: Start date should be earlier than end date."))
      
      if(input$type=='DEBIT')
      {
        UserDebit <-
          aggregate(select(UserData[UserData$type == 'DEBIT', ], -type)['amount'], by =
                      select(UserData[UserData$type == 'DEBIT', ], -type)['date'], sum)
        UserDebit%>%
          filter(date > input$date[1] & date < input$date[2])
      }else if(input$type=='CREDIT')
      { 
        UserCredit <-
          aggregate(select(UserData[UserData$type == 'CREDIT', ], -type)['amount'], by =
                      select(UserData[UserData$type == 'CREDIT', ], -type)['date'], sum)
        UserCredit%>%
          filter(date > input$date[1] & date < input$date[2])
      }else if(input$type=='CHECK')
      {
        UserCheck <-
          aggregate(select(UserData[UserData$type == 'CHECK', ], -type)['amount'], by =
                      select(UserData[UserData$type == 'CHECK', ], -type)['date'], sum)
        UserCheck%>%
          filter(date > input$date[1] & date < input$date[2])
      }else
      {
        UserDSLIP <-
          aggregate(select(UserData[UserData$type == 'DSLIP', ], -type)['amount'], by =
                      select(UserData[UserData$type == 'DSLIP', ], -type)['date'], sum)
        UserDSLIP%>%
          filter(date > input$date[1] & date < input$date[2])
      }
    })
    
    # Create scatterplot object the plotOutput function is expecting
    output$lineplot <- renderPlot({
      color = "#434343"
      par(mar = c(4, 4, 1, 1))
      plot(x = selected_User()$date, y = selected_User()$amount, type = "l",
           xlab = "Date", ylab = "Amount", col = color, fg = color, col.lab = color, col.axis = color)
      # Display only if smoother is checked
      if(input$smoother){
        smooth_curve <- lowess(x = as.numeric(selected_User()$date), y = selected_User()$amount, f = input$f)
        lines(smooth_curve, col = "#E6553A", lwd = 3)
      }
    })

})
