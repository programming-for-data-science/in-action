# dplyr in Action: Analyzing Flight Data

# Load the `nycflights13` package to access the `flights` data frame
install.packages("nycflights13") # once per machine
library("nycflights13")          # in each relevant script
library("dplyr")                 # load the dplyr library
library("ggplot2")               # for plotting

# Getting to know the data set
?flights          # read the available documentation
dim(flights)      # check the number of rows/columns
colnames(flights) # inspect the column names
View(flights)      # look at the data frame in the RStudio Viewer

# Identify the airline (`carrier`) that has the highest number of delayed flights
has_most_delays <- flights %>%            # start with the flights
  group_by(carrier) %>%                   # group by airline (carrier)
  filter(dep_delay > 0) %>%               # find only the delays
  summarize(num_delay = n()) %>%          # count the observations
  filter(num_delay == max(num_delay)) %>% # find most delayed
  select(carrier)                         # select the airline

# Get name of the most delayed carrier
most_delayed_name <- has_most_delays %>%  # start with the previous answer
  left_join(airlines, by = "carrier") %>% # join on airline ID
  select(name)                            # select the airline name

print(most_delayed_name$name) # access the value from the tibble

# Calculate the average arrival delay (`arr_delay`) for each destination (`dest`)
most_early <- flights %>%
  group_by(dest) %>% # group by destination
  summarize(delay = mean(arr_delay)) # compute mean delay

# Compute the average delay by destination airport, omitting NA results
most_early <- flights %>%
  group_by(dest) %>% # group by destination
  summarize(delay = mean(arr_delay, na.rm = TRUE)) # compute mean delay





# Identify the destination where flights, on average, arrive most early
most_early <- flights %>%
  group_by(dest) %>% # group by destination
  summarize(delay = mean(arr_delay, na.rm = TRUE)) %>% # compute mean delay, ignore NA
  filter(delay == min(delay, na.rm = TRUE)) %>% # filter for the *least* delayed
  select(dest, delay) %>% # select the destination (and delay to store it)
  left_join(airports, by = c("dest" = "faa")) %>% # join on `airports`data frame
  select(dest, name, delay) # select output variables of interest

print(most_early)

# Identify the month in which flights tend to have the longest delays
flights %>%
  group_by(month) %>% # group by selected feature
  summarize(delay = mean(arr_delay, na.rm = TRUE)) %>% # summarize value of interest
  filter(delay == max(delay)) %>% # filter for the record of interest
  select(month) %>% # select the column that answers the question
  print() # print the tibble out directly

# Compute delay by month, adding month names for visual display
# Note, `month.name` is a variable build into R
delay_by_month <- flights %>%
  group_by(month) %>%
  summarize(delay = mean(arr_delay, na.rm = TRUE)) %>%
  select(delay) %>%
  mutate(month = month.name)

# Create a plot using the ggplot2 package (described in Chapter 17)
ggplot(data = delay_by_month) +
  geom_point(
    mapping = aes(x = delay, y = month), 
    color = "blue",
    alpha = .4, 
    size = 3
  ) +
  geom_vline(xintercept = 0, size = .25) +
  xlim(c(-20, 20)) +
  scale_y_discrete(limits = rev(month.name)) +
  labs(title = "Average Delay by Month", y = "", x = "Delay (minutes)")
  