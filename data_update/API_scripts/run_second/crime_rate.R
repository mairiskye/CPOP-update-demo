library(httr)
library(dplyr)
library(magrittr)
library(readr)

#get raw sparql conent from file
crime_sparql <- read_file("data_update/sparql/crime_rate_cpp.txt")

#query api with sparql in body
crime_response <- httr::POST(
  url = "https://statistics.gov.scot/sparql.csv",
  body = list(query = crime_sparql))

#parse response
crime_data <- content(crime_response, as = "parsed", encoding = "UTF-8") %>%
  select(!Code)

final_crime_data <- crime_data %>%
  mutate(Indicator = "Crime",
         Type = "Raw") %>%
  select(CPP, Year, Indicator, Type, value) %>%
  arrange(CPP, Year)
  
write.csv(final_crime_data, "data_update/data/crime_rate_cpp.csv", row.names = FALSE)
