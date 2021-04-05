printMainAuthority <- function() {
  tags$div(
    tags$hr(),
    tags$p("Support:"),
    tags$li("Truc Huynh business services: 800-242-7338."),
    tags$li("For online technical support, please call us at 1-877-242-7372"),
    tags$li("For help with online banking, please  contact us online")
  )
}

printWhiteSpace <- function(){
  tags$div(
  tags$br(),
  tags$br(),
  tags$br(),    
  )
}

noteCategory <- function(){
  tags$div(
    tags$h4("Note:"),
    tags$p("Select one of the following option:"),
    tags$li("DEBIT: debit balances include assets, expenses, and losses..."),
    tags$li("CREDIT: credit balances include incomes, revenue accounts, and gain accounts..."),
    tags$li("CHECK: Deposit of check(s)."),
    tags$li("DSLIP: Deposit slips (check or cash)."),
    tags$br(),)
}

printNote <- function(){
  tags$div(
    tags$a(href = "https://github.com/jackyhuynh", "Source: Private Data from Truc GitHub"),
    tags$br(),
    tags$a(href = "https://www.linkedin.com/in/truchuynhbusiness/", "Source: Linkedln")    
  )
}