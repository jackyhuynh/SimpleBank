# @Swetha
#
# Name: Main login screen
# Function: UI Component for Login Screen
# Component: UI
# Variable: Global
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

          br(),
        
        tags$div(
          splitLayout(
            cellWidths = c("200px","15", "200px"),
            cellArgs = list(style = "vertical-align: top"),
            actionButton( "login","SIGN IN",
              style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;"),
            tags$div(),
            actionButton("registerButton","REGISTER",
              
              style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;")
          )
        ),
          
        
        shinyjs::hidden(div(
          id = "nomatch",
          tags$p(
            "Incorrect username or password!",
            style = "color: red; font-weight: 600;
                                            padding-top: 5px;font-size:16px;",
            class = "text-center"
          )
        )),
        br()
      )
    )
  )
# End Main Login UI


#  @Swetha
# 
# Function: Ignore lines 64-68 as they contain static user data
# Component: UI
# Variable: Global
credentials = data.frame(
  username_id = c("myuser", "myuser1"),
  passod   = sapply(c("mypass", "mypass1"), password_store),
  permission  = c("basic", "advanced"),
  stringsAsFactors = F
)




#Form for data entry
register_form <- function() {
  showModal(modalDialog(div(
    id = ("register_form"),
    tags$head(tags$style(".modal-dialog{ width:400px}")),
    tags$head(tags$style(
      HTML(".shiny-split-layout > div {overflow: visible}")
    ))
    
    ,fluidPage(div(
      id = "uregistration",
      style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
      wellPanel(
        tags$h2("REGISTRATION FORM", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
        #textInput("name", labelMandatory("Name"), "")
        textInput(
          "userName",
          placeholder = "Username",
          value="username",
          label = tagList(icon("user"), labelMandatory("Username"))
          
        ),
        passwordInput(
          "passwd",
          placeholder = "Password",
          value="pass1",
          label = tagList(icon("unlock-alt"), labelMandatory("Password"))
        ),
        passwordInput(
          "rpasswd",
          placeholder = "Retype Password",
          value="pass1",
          label = tagList(icon("unlock-alt"), labelMandatory("Retype Password"))
        ),
        numericInput("mnumber", value = '3120690807', labelMandatory("Mobile Number")),
        textInput(
          "email",
          placeholder = "email",
          value="vgs_Raju@rediffmail.com",
          label = tagList(icon("user"), labelMandatory("EmailID"))
        ),
        # verbatimTextOutput("value"),
        numericInput(
          "ssn",
          labelMandatory("SSN"),
          value = '312069087',
          min = 9,
          max = 9,
          step = 9
        ),
        textInput(
          "ccnum",
          placeholder = "CreditCardNumber",
          value = '4312069087312069',
          label = tagList(icon("credit-card"), labelMandatory("CREDITCARD NUMBER"))
        ),
        #   numericInput("ccnum","CREDITCARD NUMBER",value = 0,min = 16,max=16),
        textInput(
          "ccname",
          placeholder = "CCNAME",
          value = 'Name onthe Card',
          label = tagList(icon("user"), labelMandatory("Name On Credit Card"))
        ),
        dateInput(
          "expiry",
          labelMandatory("EXPIRY DATE"),
          value = NULL,
          format = " yyyy-mm-dd ",
          startview = "month",
          weekstart = 0,
          language = "en",
          width = NULL,
          autoclose = TRUE,
          datesdisabled = NULL,
          daysofweekdisabled = NULL
        ),
        
        
      ),
      # div (class="form-body",
      # Card Number
      #    input (type ="text", class="card-number", placeholder="Card Number")),
      
      div(
        style = "text-align: center;",
        useShinyalert(),
        # Set up shinyalert
        actionButton(
          "register",
          "REGISTER",
          style = "color: white; background-color:#3c8dbc;
                         padding: 10px 15px; width: 150px; cursor: pointer;
                         font-size: 18px; font-weight: 600;"
        ),
        shinyjs::hidden(div(
          id = "nomatch",
          tags$p(
            "Registration Failed!",
            style = "color: red; font-weight: 600;
                                    padding-top: 5px;font-size:16px;",
            class = "text-center"
          )
        )),
        #  plotOutput('plot')
      )
    ))
  )))
}

