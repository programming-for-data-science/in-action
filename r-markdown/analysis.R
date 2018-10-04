# R Markdown in Action: Reporting on Life Expectancy

# Load required libraries
library(dplyr)
library(rworldmap) # for easy mapping
library(RColorBrewer) # for selecting a color palette

# Load the data, skipping unnecessary rows
life_exp <- read.csv(
  "data/API_SP.DYN.LE00.IN_DS2_en_csv_v2.csv",
  skip = 4,
  stringsAsFactors = FALSE
)

# Notice that R puts the letter "X" in front of each year column,
# as column names can't begin with numbers

# Which country had the longest life expectancy in 2015?
longest_le <- life_exp %>%
  filter(X2015 == max(X2015, na.rm = T)) %>%
  select(Country.Name, X2015) %>%
  mutate(expectancy = round(X2015, 1)) # rename and format column

# Which country had the shortest life expectancy in 2015?
shortest_le <- life_exp %>%
  filter(X2015 == min(X2015, na.rm = T)) %>%
  select(Country.Name, X2015) %>%
  mutate(expectancy = round(X2015, 1)) # rename and format column

# Calculate range in life expectancies
le_difference <- longest_le$expectancy - shortest_le$expectancy

# What are the 10 countries that experienced the greatest gain in life expectancy?
top_10_gain <- life_exp %>%
  mutate(gain = X2015 - X1960) %>%
  top_n(10, wt = gain) %>% # a handy dplyr function!
  arrange(-gain) %>%
  mutate(gain_formatted = paste(format(round(gain, 1), nsmall = 1), "years")) %>%
  select(Country.Name, gain_formatted)

# Join this data frame to a shapefile that describes how to draw each country
# The `rworldmap` package provides a helpful function for doing this
mapped_data <- joinCountryData2Map(
  life_exp,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)