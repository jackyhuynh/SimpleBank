# Exepense_Tracking_and_Analysis

## [CHECK IT OUT](https://www.loom.com/share/64f48d26c0de4ebeb174e3b1dd9dac01)

## Ver.03
- This is the 3rd Version of the App. Feature with data from the database and full feature of Extracting and Centralizing data.
- Make sure you download and set up the MySQL Server(and connect to the database that I include in the data section) otherwise app will not work

## Feature
- Full connection to My SQL Server.
- Full Edit and retrive data from the database.
- Data Integration
- Code Clean Up

## Run App:
### Set Up My SQL Server
1. Download My SQL Workbench:
- Download the newest version of MySQL Server (https://dev.mysql.com/downloads/mysql/)
- Please download the newest version of MySQL WorkBench on a local machine (https://dev.mysql.com/downloads/workbench/)
- After Download the My SQL WorkBench (full version) set it up and write down the <b>root username</b> and <b>password</b> ( we will need it to make the connection as well as set up the MySQL Server)
#### Run MySQL Server Script:
- Run my SQL Server Script in the data folder, open My SQL WorkBench and execute all the script in the CreateDataBaseFile_V2 (SQL Text File) file 


### Set Up R Studio:
- Download the lastest version of RStudio (https://www.rstudio.com/products/rstudio/download/)
#### Instal Needed Library
- Install all the needed package by using the PrepareScript: Simply open the file and execute the script

#### Set workspace to current directory
- getwd() to find the current directory
- Using the setwd() command to set the current workspace to the SubmissionVersion
- For Example in my case: setwd("C:/Users/Valued Customer/Documents/source/R-DeepExpenseAnalyst/SubmissionVersion")

#### Set Up Connection:
- Go to SubmissionVersion/modules/sql_api.R and change the following code (on the top of the script)
```
# @ Wrucha
##Only change user, password and host
getConnection <- function(){
  connection = dbConnect(MySQL(), user = 'your root go here', password = 'your Password go here', dbname = 'credit_card_analysis3',
                         host = 'localhost');
  return(connection);
};
```
- Inside dbConnect(MySQL(), user = 'your root go here', password = 'your Password go here', ...
- Set user=SQL username (your My SQL root username)
- Set password= SQL password (your My SQL root password)
- Please save all the changes before moving foward

#### Run the app
- Make sure MySQL server is runining in the back ground
- Now Simply open the app.R and hit execute the app
- It should run as it should

## Introduction
The Expense Tracking and Analysis is a web application that built with R Shiny, JavaScript, HTML, CSS. The app features password complexity and encryption and allowing multiple users(each user have their own table) to get access to the resource with the right username and password. Expense Tracking allows user to track their expense in that month (or a period). Just like other budget application: The app will category the user’s expense base on a server’s database, display bank statements, expense statements. The user also has the power to change the expense category, track their expense, change user profile, card details, personal info, and so much more. The Expense Tracking and Analysis also feature with AI to advise user with better spending habit (base on a user’s database and machine learning methodologies). App use MySQL to host data and R technology to design front and backend. Can be deploy using Docker.

## Team member:
    - Truc Huynh
    - Wrucha Nanal
    - Kristina Bond
    - Swetha Gidugu


### We should be able to build the following prototype(Web application) of the system:
    - Design a database
    - Build GUI
    - Dashboard which generates graphs 
    - View the transaction and update the transaction's list.
    - Simulate and generate the report.


### Component:
    - Back End (Database/Sever): MySQL, R
    - Front End (Gui, Database/Client/Machine Learning): R, Python, JavaScript, HTML
    - Development Framework: R Shiny

## Technology:
[Microsoft AI platform](https://docs.microsoft.com/en-us/archive/msdn-magazine/2017/connect/artificial-intelligence-getting-started-with-microsoft-ai)

[R Shiny](https://shiny.rstudio.com/)
  


    
