# SET OF METHODS FOR DISPLAY HTML AND CSS BLOCK


# @Truc
# 
printMainAuthority <- function() {
  tags$div(
    tags$hr(),
    tags$p("Support:"),
    tags$li("Financial Freedom team business services: 800-242-7338."),
    tags$li("For online technical support, please call us at 1-877-242-7372"),
    tags$li("For help with online banking, please  contact us online")
  )
}


# @Truc
# 
printWhiteSpace <- function(){
  tags$div(
  tags$br(),
  tags$br(),
  tags$br(),    
  )
}


# @Truc
# 
noteTransactionType <- function(){
  tags$div(
    tags$h4("Note:"),
    tags$p("Select one of the following option:"),
    tags$li("DEBIT: debit balances include assets, expenses, and losses..."),
    tags$li("CREDIT: credit balances include incomes, revenue accounts, and gain accounts..."),
    tags$li("CHECK: Deposit of check(s)."),
    tags$li("DSLIP: Deposit slips (check or cash)."),
    tags$br(),)
}


# @Truc
# 
noteTransactionMap <- function(){
  tags$div(
    tags$br(),
    tags$p("Transaction Map show user's transaction over time, feature with:"),
    tags$li("MOVE CLOSE to destination to see Store Name. "),
    tags$li("CLICK ON marker to see the total amount over time."),
    tags$li("ZOOM IN to see street details."),
    tags$li("ZOOM OUT to see the over all maps."),
    tags$br())
}


# @Truc
# 
printNote <- function(){
  tags$div(
    tags$a(href = "https://github.com/jackyhuynh", "Source: Private Data from Truc GitHub"),
    tags$br(),
    tags$a(href = "https://www.linkedin.com/in/truchuynhbusiness/", "Source: Linkedln")    
  )
}


# @Truc
# Label mandatory fields
labelMandatory <- function(label) {
  tagList(label,span("*", class = "mandatory_star")
  )}