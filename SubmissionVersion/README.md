# Personal_Expense_Analyst

## Ver.03
This is the 4th Version of the App. Feature with data from the database and full feature of Extracting and Centralizing data.

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
  connection = dbConnect(MySQL(), user = 'root', password = 'Myskhongbiet88', dbname = 'credit_card_analysis3',
                         host = 'localhost');
  return(connection);
};
```
- Inside dbConnect(MySQL(), user = 'root', password = 'Myskhongbiet88', ...
- Set user=SQL username (your My SQL root username)
- Set password= SQL password (your My SQL root password)
- Please save all the changes before moving foward

#### Run the app
- Make sure MySQL server is runining in the back ground

- Now Simply open the app.R and hit execute the app
- It should run as it should

- If you encounter any issues please contact me at Truc(408-896-3449)
