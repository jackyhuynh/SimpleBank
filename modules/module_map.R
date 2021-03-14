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



pie3D(
  UserTransaction$Amount,
  labels = UserTransaction$category,
  height = 0.05,
  radius = 1.5,
  explode = 0.3,
  shade = 0.7,
  broder= 'white',
  col = heat.colors(length(UserTransaction$Amount))
)

# legend("topright", UserTransaction$category, 
#        cex = 0.7, fill = heat.colors(length(UserTransaction$Amount)))

