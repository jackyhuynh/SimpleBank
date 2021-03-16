library("tidyverse")
library("leaflet")
library("plotrix")



data(quakes)

# Show first 20 rows from the `quakes` dataset
leaflet(data = quakes[1:20,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(mag), label = ~as.character(mag))

head(quakes)

location <- read_csv("location.csv")

# MAPMODULE
leaflet(data = location) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup =~as.character(Amount), label = ~as.character(store))


transactions <- read_csv("transactions.csv")
transactions$Category <- as.factor(transactions$category)
summary(transactions)


UserTransaction <-
  aggregate(select(transactions[transactions$type == 'debit', ], -type)['Amount'], by =
              select(transactions[transactions$type == 'debit', ], -type)['category'], sum)

# Sort the User Transaction
UserTransaction <- UserTransaction[order(-UserTransaction[,2]),]

UserTransaction$TransPercent <- scales::percent(as.numeric(UserTransaction$Amount/sum(UserTransaction$Amount)))


UserBigTransaction <- filter(UserTransaction, UserTransaction$TransPercent>1)

c("other expense",
  sum(UserTransaction$Amount)-sum(UserBigTransaction$Amount),
  (sum(UserTransaction$Amount)-sum(UserBigTransaction$Amount))/sum(UserTransaction$Amount))


par(mar = c(1, 1, 1, 1)) # bltr

pie(
  Type, 
  edges = 200, 
  radius = 0.8,
  clockwise = TRUE, # IMPORTANT
  angle = 45, 
  col = viridis::viridis_pal(option = "magma", direction=-1)(length(UserTransaction$Amount)),  # BETTER COLOR PALETTE
  labels = tail(piepercent, -7), # NEVER DISPLAY OVERLAPPING LABELS
  cex = 0.7
)

legend(
  x = 1.2, # DELIBERATE POSITION
  y = 0.5, # DELIBERATE POSITION
  inset = .05, 
  title = "Primary Crime Type", 
  legend = names(Type), # YOU WERE PASSING IN _ALL_ THE REPEAT NAMES
  fill = viridis::viridis_pal(option = "magma", direction=-1)(length(Type)),  # USE THE SAME COLOR PALETTE
  horiz = FALSE,
  cex = 0.6, # PROPER PARAMETER FOR TEXT SIZE
  text.width = 0.7 # SET THE BOX WIDTH
)



