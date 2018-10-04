# `tidyr` in action: Exploring Educational Statistics

# Load the necessary libraries
library(tidyr) # for data wrangling
library(dplyr) # for data wrangling
library(ggplot2) # for plotting
library(ggrepel) # for plotting
library(scales) # for plotting

# Load data, skipping the unnecessary first 4 rows
wb_data <- read.csv(
  "data/world_bank_data.csv",
  stringsAsFactors = F,
  skip = 4
)

# Visually compare expenditures for 1990 and 2014
# Begin by filtering the rows for the indicator of interest
indicator <- "Government expenditure on education, total (% of GDP)"
expenditure_plot_data <- wb_data %>%
  filter(Indicator.Name == indicator)

# Plot the expenditure in 1990 against 2014 using the `ggplot2` package
# See Chapter 16 for details
expenditure_chart <- ggplot(data = expenditure_plot_data) +
  geom_text_repel(
    mapping = aes(x = X1990 / 100, y = X2014 / 100, label = Country.Code)
  ) +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = percent) +
  labs(
    title = indicator, x = "Expenditure 1990",
    y = "Expenditure 2014"
  )

# Reshape the data to create a new column for the `year`
long_year_data <- wb_data %>%
  gather(
    key = year, # `year` will be the new key column
    value = value, # `value` will be the new value column
    X1960:X # all columns between `X1960` and `X` will be gathered
  )


# Filter the rows for the indicator and country of interest
indicator <- "Government expenditure on education, total (% of GDP)"
spain_plot_data <- long_year_data %>%
  filter(
    Indicator.Name == indicator,
    Country.Code == "ESP" # Spain
  ) %>%
  mutate(year = as.numeric(substr(year, 2, 5))) # remove "X" before each year

# Show the educational expenditure over time
chart_title <- paste(indicator, " in Spain")
spain_chart <- ggplot(data = spain_plot_data) +
  geom_line(mapping = aes(x = year, y = value / 100)) +
  scale_y_continuous(labels = percent) +
  labs(title = chart_title, x = "Year", y = "Percent of GDP Expenditure")

# Reshape the data to create columns for each indicator
wide_data <- long_year_data %>%
  select(-Indicator.Code) %>% # do not include the `Indicator.Code` column
  spread(
    key = Indicator.Name, # new column names are `Indicator.Name` values
    value = value # populate new columns with values from `value`
  )

# Prepare data and filter for year of interest
x_var <- "Literacy rate, adult female (% of females ages 15 and above)"
y_var <- "Unemployment, female (% of female labor force) (modeled ILO estimate)"
lit_plot_data <- wide_data %>%
  mutate(
    lit_percent_2014 = wide_data[, x_var] / 100,
    employ_percent_2014 = wide_data[, y_var] / 100
  ) %>%
  filter(year == "X2014")

# Show the literacy vs. employment rates
lit_chart <- ggplot(data = lit_plot_data) +
  geom_point(mapping = aes(x = lit_percent_2014, y = employ_percent_2014)) +
  scale_x_continuous(labels = percent) +
  scale_y_continuous(labels = percent) +
  labs(
    x = x_var,
    y = "Unemployment, female (% of female labor force)",
    title = "Female Literacy Rate versus Female Unemployment Rate"
  )
