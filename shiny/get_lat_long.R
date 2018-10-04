# Geocode addresses: based on the following blog post
# http://www.storybench.org/geocode-csv-addresses-r/

# Use dev version of ggmaps so that you can set the Google Maps API key
# devtools::install_github("dkahle/ggmap")
library(ggmap)
library(dplyr)

# Load and google maps API key (you'll need to get your own)
source("api_key.R")
register_google(key = google_key)

# Load data from GitHub
data_url <- "https://raw.githubusercontent.com/washingtonpost/data-police-shootings/master/fatal-police-shootings-data.csv"
shootings <- read.csv(data_url, stringsAsFactors = F) %>%
  mutate(
    address = paste0(city, ", ", state)
  ) %>% 
  filter(as.Date(date) >= as.Date("2018-01-01"))

# Get addresses
shootings[, c("long", "lat")] <- geocode(shootings$address)

# Replace values
shootings$race[shootings$race == "W"] <- "White, non-Hispanic"
shootings$race[shootings$race == "B"] <- "Black, non-Hispanic"
shootings$race[shootings$race == "A"] <- "Asian"
shootings$race[shootings$race == "N"] <- "Native American"
shootings$race[shootings$race == "H"] <- "Hispanic"
shootings$race[shootings$race == "O"] <- "Other"
shootings$race[shootings$race == ""] <- "Unknown"

shootings$gender[shootings$gender == "M"] <- "Male"
shootings$gender[shootings$gender == "F"] <- "Female"
shootings$gender[shootings$gender == ""] <- "Unknown"

# Write a CSV file containing the data
write.csv(shootings, "police-shootings.csv", row.names = FALSE)
