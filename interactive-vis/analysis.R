# Interactive Visualization in Action: Exploring Changes to the City of Seattle

# Load required packages
library(plotly)
library(dplyr)
library(leaflet)

# Load data downloaded from https://data.seattle.gov/Permitting/Building-Permits/76t5-zqzr
all_permits <- read.csv("data/Building_Permits.csv", stringsAsFactors = FALSE)

# Filter for permits for new buildings issued in 2010 or later
new_buildings <- all_permits %>%
  filter(
    PermitTypeDesc == "New",
    PermitClass != "N/A",
    as.Date(all_permits$IssuedDate) >= as.Date("2010-01-01") # filter by date
  )

# Create a new column storing the year the permit was issued
new_buildings <- new_buildings %>%
  mutate(year = substr(IssuedDate, 1, 4)) # extract the year

# Calculate the number of permits issued by year
by_year <- new_buildings %>%
  group_by(year) %>%
  count()

# Use plotly to create an interactive visualization of the data
plot_ly(
  data = by_year, # data frame to show
  x = ~year,      # variable for the x-axis, specified as a formula
  y = ~n,         # variable for the y-axis, specified as a formula
  type = "bar",   # create a chart of type "bar" -- a bar chart
  alpha = .7,     # adjust the opacity of the bars
  hovertext = "y" # show the y-value when hovering over a bar
) %>%
  layout(
    title = "Number of new building permits per year in Seattle",
    xaxis = list(title = "Year"),
    yaxis = list(title = "Number of Permits")
  )

# Create a Leaflet map, adding map tiles and circle markers
leaflet(data = new_buildings) %>%
  addProviderTiles("CartoDB.Positron") %>%
  setView(lng = -122.3321, lat = 47.6062, zoom = 10) %>%
  addCircles(
    lat = ~Latitude, # specify the column for `lat` as a formula
    lng = ~Longitude, # specify the column for `lng` as a formula
    stroke = FALSE, # remove border from each circle
    popup = ~Description # show the description in a popup
  )

# Construct a function that returns a color based on the PermitClass column
# Colors are taken from the ColorBrewer Set3 palette
palette_fn <- colorFactor(palette = "Set3", domain = new_buildings$PermitClass)

# Create a Leaflet map of new building construction by category
leaflet(data = new_buildings) %>%
  addProviderTiles("CartoDB.Positron") %>%
  setView(lng = -122.3321, lat = 47.6062, zoom = 10) %>% 
  addCircles(
    lat = ~Latitude, # specify the column for `lat` as a formula
    lng = ~Longitude, # specify the column for `lng` as a formula
    stroke = FALSE, # remove border from each circle
    popup = ~Description, # show the description in a popup
    color = ~palette_fn(PermitClass), # a "function of" the palette mapping
    radius = 20, # radius of each circle (in meters)
    fillOpacity = 0.5 # opacity of the fill
  ) %>%
  addLegend( # Add a legend layer in the "bottomright" of the map
    position = "bottomright",
    title = "New Buildings in Seattle",
    pal = palette_fn, # the palette to label
    values = ~PermitClass, # the values to label
    opacity = 1
  )

  