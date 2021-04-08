# The original data is used for display only
UserData.Tidy  <- read_csv("data/data.CSV", col_types = cols(date = col_date(format = "%m/%d/%Y")))

# Set the Type to NULL
UserData.Tidy$type <- NULL

# The total balance over time
TotalBalance <-
  aggregate(select(UserData.Tidy,-c(details))['balance'], select(UserData.Tidy,-c(details))['date'], last)