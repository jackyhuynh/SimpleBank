library("tidyverse")
library("leaflet")
library("plotrix")
library("data.table")


data(quakes)

# Show first 20 rows from the `quakes` dataset
leaflet(data = quakes[1:20,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(mag), label = ~as.character(mag))

head(quakes)

location <- read_csv("location.csv")

# MAPMODULE
leaflet(data = location) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup =~as.character(Amount), label = ~as.character(store))

# import the data
transactions <- read_csv("transactions.csv")

# change the category to factor
# transactions$category <- as.factor(transactions$category)

# Summary by debit and type
UserTransaction <-
  aggregate(select(transactions[transactions$type == 'debit', ], -type)['Amount'], by =
              select(transactions[transactions$type == 'debit', ], -type)['category'], sum)

# Filter the big transaction
SumTransaction <- filter(UserTransaction, as.numeric(UserTransaction$Amount/sum(UserTransaction$Amount)) > 0.005)

# Calculate the percentage of all Transactions smaller than 1 percent
OtherTransaction <- data.frame("Other Expenses",
                                sum(UserTransaction$Amount) - sum(SumTransaction$Amount))

# Rename the value
names(OtherTransaction) <- c('category','Amount')

# Get the total transaction after summary the transaction less than 1 percent
SumTransaction<- rbind(SumTransaction,OtherTransaction)

# Sort the SumTransaction
SumTransaction <- SumTransaction[order(-SumTransaction[,2]),]

piepercent <- scales::percent(as.numeric(SumTransaction$Amount/sum(SumTransaction$Amount)))


par(mar = c(1, 1, 1, 1)) # bltr

pie(
  SumTransaction$Amount, 
  edges = 200, 
  radius = 0.8,
  clockwise = TRUE, # IMPORTANT
  angle = 45, 
  col = viridis::viridis_pal(option = "magma", direction=-1)(length(SumTransaction$Amount)),  # BETTER COLOR PALETTE
  labels = tail(piepercent, -4), # NEVER DISPLAY OVERLAPPING LABELS
  cex = 0.7,
  border="white",
)



