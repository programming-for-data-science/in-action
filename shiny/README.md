# Shiny in Action: Visualizing Fatal Police Shootings

This section demonstrates building a Shiny application to visualize a data set of people who were fatally shot by the police in the United States in the first half of 2018 (January through June). The data set was compiled by the [Washington Post](https://www.washingtonpost.com/graphics/2018/national/police-shootings-2018/?utm_term=.d5d3a88f97da), who made the data available on [GitHub](https://github.com/washingtonpost/data-police-shootings).

In order to visualize the geographic distribution of the data, latitude and longitude were added to each observation in the data using [this code](add_lat_long.R) (you don't need to run that script, but it has been included to show how this was done). Note, executing that script requires an [Google Maps API Key](https://developers.google.com/maps/documentation/geocoding/get-api-key). 

As is our suggested structure for building a Shiny application, this application is written in a single [`app.R`](app.R) file. To see the application running, open the file in R Studio and click the _Run App_ button. A screenshot of the interactive application is shown below.

![Interactive map of fatal police shootings](imgs/shooting-app.png)

 