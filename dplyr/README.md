# `dplyr` in Action: Analyzing Flight Data

In this section, you will learn how `dplyr` functions can be used to ask interesting questions of a more complex data set  You’ll use a data set of flights that departed from New York city airports (including Newark, John F. Kennedy, and Laguardia airports) in 2013. This data set is also featured online in the Introduction to dplyr [vignette](https://dplyr.tidyverse.org/articles/dplyr.html), and is drawn from the Bureau of Transportation Statistics database.

This dataset will use over 300,000 observations to ask the following questions:

1. Which _airline_ has the _highest number of delayed_ departures?
2. On _average_, to which _airport_ do flights arrive _most early_?
3. In which _month_ do flights tend to have the longest delays?

See all code in the [`analysis.R`](analysis.R) file.