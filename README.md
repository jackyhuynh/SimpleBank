# Exepense_Tracking_and_Analysis

## [CHECK IT OUT](https://www.loom.com/share/64f48d26c0de4ebeb174e3b1dd9dac01)

## Introduction:
- This is the 3rd Version of the App. Feature with data from the database and full feature of Extracting and Centralizing data.
- Make sure you download and set up the MySQL Server(and connect to the database that I include in the data section) otherwise app will not work
- Multiple user with multiple database.
<img src="https://github.com/jackyhuynh/User_Banking_and_Expense_Analyst/blob/master/images/miniversion_AdobeCreativeCloudExpress.gif">

## Structure:
#### Diagram:
App structure diagram:
* Feature password salting
* password recover
* multiple users own their seperate data
* register new user
<img src="https://github.com/jackyhuynh/User_Banking_and_Expense_Analyst/blob/master/images/useCaseDiagram.PNG">

#### Register Page:
- Register new user with all the validation: cards validation, passwords validation, email validation
<img src="https://github.com/jackyhuynh/User_Banking_and_Expense_Analyst/blob/master/images/registration-user-info.PNG">
- verify new user
<img src="https://github.com/jackyhuynh/User_Banking_and_Expense_Analyst/blob/master/images/registration-verification.PNG">
- reset password:
<img src="https://github.com/jackyhuynh/User_Banking_and_Expense_Analyst/blob/master/images/reset-password.PNG">

#### Home Page:
- Home page has the total expense map that caculate the total user expense at specific location (since account is open).
- The data table that store the user's transactions.
<img src="https://github.com/jackyhuynh/User_Banking_and_Expense_Analyst/blob/master/images/home.JPG">

#### Banking Page:
- Store the user debit and credit transaction.
- Analyst user expense using diffrent analyst methods.
<img src="https://github.com/jackyhuynh/User_Banking_and_Expense_Analyst/blob/master/images/banking.JPG">

#### Cards-analyst Page:
- Analyst the spending power of a credit card compare to other cards.
<img src="https://github.com/jackyhuynh/User_Banking_and_Expense_Analyst/blob/master/images/cards-analyst.JPG">

#### Category-analyst Page:
- Analyst user expense by category.
<img src="https://github.com/jackyhuynh/User_Banking_and_Expense_Analyst/blob/master/images/category-analyst.JPG">

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


## Component:
- Back End (Database/Sever): MySQL, R
- Front End (Gui, Database/Client/Machine Learning): R, Python, JavaScript, HTML
- Development Framework: R Shiny

## Technology
List of technology
- R Studio
- Business Analyst
- Machine Learning
- Data Mining
- Data Visualization
- Machine Learning

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Data:
Information about the data

### Prerequisites
What things you need to install the software and how to install them:
- R CRAN Project: R is a free software environment for statistical computing and graphics. It compiles and runs on a wide variety of UNIX platforms, Windows and MacOS
- RStudio IDE: RStudio is an integrated development environment (IDE) for R. It includes a console, syntax-highlighting editor that supports direct code execution, as well as tools for plotting, history, debugging and workspace management. Click here to see more RStudio features. RStudio is available in open source and commercial editions and runs on the desktop (Windows, Mac, and Linux) or in a browser connected to RStudio Server or RStudio Server Pro (Debian/Ubuntu, Red Hat/CentOS, and SUSE Linux)

### Installing
A step by step series of examples that tell you how to get a development enviroment running:
* [Install R](https://www.r-project.org/) - If you haven't downloaded and installed R, here's how to get started.
* [R Studio IDE](https://rstudio.com/products/rstudio/#:~:text=RStudio%20Take%20control%20of%20your%20R%20code%20RStudio,tools%20for%20plotting,%20history,%20debugging%20and%20workspace%20management.) - After that choose R Studio Desktop, and the free version (unless you have the Pro install). R free version is pretty good IDE.

## Built With
* [R Studio IDE](https://rstudio.com/products/rstudio/#:~:text=RStudio%20Take%20control%20of%20your%20R%20code%20RStudio,tools%20for%20plotting,%20history,%20debugging%20and%20workspace%20management.) 
* [R CRAN Project](https://www.r-project.org/) 

## Authors

* **Truc Huynh** - *Initial work* - [TrucDev](https://github.com/jackyhuynh)
* **Wrucha Nanal** - *Initial work* -
* **Kristina Bond** - *Initial work* -
* **Swetha Gidugu** - *Initial work* -

## Contribute:
This project is closed and private, no contributing.


    
