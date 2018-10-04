# ggplot2 in Action:Mapping Evictions in San Francisco

# Load packages for data wrangling and visualization
library("dplyr")
library("tidyr")

# You need to use a particular branch of the development version of ggmap 
# by running this code
library(devtools) # for installing packages from GitHub
devtools::install_github("dkahle/ggmap", ref = "tidyup")
library(ggmap)

# Load .csv file of notices
# Data downloaded from https://catalog.data.gov/dataset/eviction-notices
eviction_notices <- read.csv("data/Eviction_Notices.csv", stringsAsFactors = F)

# Data wrangling: format dates, filter to 2017 notices, extract lat/long data
notices <- eviction_notices %>%
  mutate(date = as.Date(File.Date, format="%m/%d/%y")) %>%
  filter(format(date, "%Y") == "2017") %>%
  separate(Location, c("lat", "long"), ", ") %>% # split the column at the comma
  mutate(
    lat = as.numeric(gsub("\\(", "", lat)), # remove starting parentheses
    long = as.numeric(gsub("\\)", "", long)) # remove closing parentheses
  ) 

# Create a map of San Francisco, with a point at each eviction notice address

# Register your Google API Key
# See: https://developers.google.com/maps/documentation/geocoding/get-api-key
register_google(key="YOUR_GOOGLE_KEY")

# Create the background of map tiles
base_plot <- qmplot(
  data = notices,               # name of the data frame
  x = long,                     # data feature for longitude
  y = lat,                      # data feature for latitude
  geom = "blank",               # don't display data points (yet)
  maptype = "toner-background", # map tiles to query
  darken = .7,                  # darken the map tiles
  legend = "topleft"            # location of legend on page
)

# Add the locations of evictions to the map
base_plot +
  geom_point(mapping = aes(x = long, y = lat), color = "red", alpha = .3) +
  labs(title = "Evictions in San Francisco, 2017") +
  theme(plot.margin = margin(.3, 0, 0, 0, "cm")) # adjust spacing around the map

# Draw a heatmap of eviction rates, using ggplot2 to compute the shape/color of contours
base_plot +
  geom_polygon(
    stat = "density2d", # calculate the two-dimensional density of points (contours)
    mapping = aes(fill = stat(level)), # use the computed density to set the fill
    alpha = .3 # Set the alpha (transparency)
  ) +
  scale_fill_gradient2("# of Evictions", low = "white", mid = "yellow", high = "red") +
  labs(title="Number of Evictions in San Francisco, 2017") +
  theme(plot.margin = margin(.3, 0, 0, 0, "cm"))
