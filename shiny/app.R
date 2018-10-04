library(shiny)
library(dplyr)
library(leaflet)

# Load the prepared data
shootings <- read.csv("data/police-shootings.csv", stringsAsFactors = FALSE)

# Define UI for application that renders the map and table
my_ui <- fluidPage(
  # Application title
  titlePanel("Fatal Police Shootings"),
  # Sidebar with a selectInput for the variable for analysis
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "analysis_var",
        label = "Level of Analysis",
        choices = c("gender", "race", "body_camera", "threat_level")
      )
    ),
    # Display the map and table in the main panel
    mainPanel(
      leafletOutput("shooting_map"), # reactive output provided by leaflet
      tableOutput("grouped_table")
    )
  )
)

# Define server that renders a map and a table
my_server <- function(input, output) {
  # Define a map to render in the UI
  output$shooting_map <- renderLeaflet({
    # Construct a color palette (scale) based on chosen analysis variable
    palette_fn <- colorFactor(palette = "Dark2", domain = shootings[[input$analysis_var]])
    
    # Create and return the map
    leaflet(data = shootings) %>%
      addProviderTiles("Stamen.TonerLite") %>% # add Stamen Map Tiles
      addCircleMarkers( # add markers for each shooting
        lat = ~lat,
        lng = ~long,
        label = ~paste0(name, ", ", age), # add a label: each victim's name and age
        color = ~palette_fn(shootings[[input$analysis_var]]), # color by input variable
        fillOpacity = .7,
        radius = 4,
        stroke = FALSE
      ) %>%
      addLegend( # include a legend on the plot
        "bottomright",
        title = "race",
        pal = palette_fn, # the palette to label
        values = shootings[[input$analysis_var]], # again, using double-bracket notation
        opacity = 1 # legend is opaque
      )
  })
  
  # Define a table to render in the UI
  output$grouped_table <- renderTable({
    table <- shootings %>%
      group_by(shootings[[input$analysis_var]]) %>%
      count() %>%
      arrange(-n)
    colnames(table) <- c(input$analysis_var, "Number of Victims") # format column names
    
    table # return the table
  })
}
# Start running the application
shinyApp(ui = my_ui, server = my_server)