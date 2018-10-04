# APIS in Action: Finding Cuban Food in Seattle

# Load required packages
library(httr)
library(jsonlite)
library(dplyr)
library(ggrepel)

# You need to use a particular branch of the development version of ggmap 
# by running this code
library(devtools) # for installing packages from GitHub
devtools::install_github("dkahle/ggmap", ref = "tidyup")
library(ggmap)

# Register your Google API Key
# See: https://developers.google.com/maps/documentation/geocoding/get-api-key
register_google(key="YOUR_GOOGLE_KEY")

# Load your Yelp API key from a separate file so that you can access the API:
source("api_key.R") # the `yelp_key` variable is now available

# Construct a search query for the Yelp Fusion API's Business Search endpoint
base_uri <- "https://api.yelp.com/v3"
endpoint <- "/businesses/search"
search_uri <- paste0(base_uri, endpoint)

# Store a list of query parameters for Cuban restaurants around Seattle
query_params <- list(
  term = "restaurant",
  categories = "cuban",
  location = "Seattle, WA",
  sort_by = "rating",
  radius = 8000 # measured in meters, as detailed in the documentation
)

# Make a GET request, including the API key (as a header) and the list of
# query parameters
response <- GET(
  search_uri,
  query = query_params,
  add_headers(Authorization = paste("bearer", yelp_key))
)

# Parse results and isolate data of interest
response_text <- content(response, type = "text")
response_data <- fromJSON(response_text)

# Inspect the response data
names(response_data) # [1] "businesses" "total" "region"

# Flatten the data frame stored in the `businesses` key of the response
restaurants <- flatten(response_data$businesses)


# Modify the data frame for analysis and presentation
# Generate a rank of each restaurant based on row number
restaurants <- restaurants %>%
  mutate(rank = row_number()) %>%
  mutate(name_and_rank = paste0(rank, ". ", name))

# Create a base layer for the map (Google Maps image of Seattle)
base_map <- ggmap(
  get_map(
    location = c(-122.3321, 47.6062),
    zoom = 11,
    source = "google")
)

# Add labels to the map based on the coordinates in the data
base_map + geom_label_repel(
  data = restaurants,
  aes(x = coordinates.longitude, y = coordinates.latitude, label = name_and_rank)
)
