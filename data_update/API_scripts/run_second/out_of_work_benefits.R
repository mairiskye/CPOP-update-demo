#Obtains Benefit Combination Totals for those out of work from statxplore
#calculates rates using NRS MYE working age population

library(statxplorer) #available here: https://github.com/houseofcommonslibrary/statxplorer
library(magrittr)
library(dplyr)

#get and set api key from file
api_key <- config::get("api_key")
statxplorer::set_api_key(api_key)

#data from Aug 21 :
results_recent <- statxplorer::fetch_table(filename = "data_update/json/out_of_work_benefits_cpp_22_update.json")
recent_data <- results_recent$dfs$`Benefit Combinations Scotland` %>%
  filter(`Benefit Combinations (Out of Work)` == "Total",
         grepl("May", Quarter)) %>%
  rename("Benefit Combinations" = `Benefit Combinations Scotland`)

#data up until May 21:
results_historic <- statxplorer::fetch_table(filename = "data_update/json/out_of_work_benefits_cpp_historic_22_update.json")
historic_data <- results_historic$dfs$`Benefit Combinations` %>%
  filter(`Benefit Combinations (Out of Work)` == "Total",
         grepl("May", Quarter))


oowb_count <- rbind(recent_data, historic_data) %>%
  select(!`Benefit Combinations (Out of Work)`) 

names(oowb_count)[1:3] <- c("CPP", "Year", "benefit_recipient_count_at_May")

#convert year format e.g. from May-19 to 2019
oowb_count$Year <- gsub("May-", "20", oowb_count$Year)
oowb_count$Year <- as.numeric(oowb_count$Year)

oowb_count$CPP[oowb_count$CPP == "City of Edinburgh"] <- "Edinburgh, City of"
oowb_count$CPP[oowb_count$CPP == "Na h-Eileanan Siar"] <- "Eilean Siar"
oowb_count$CPP[oowb_count$CPP == "Total"] <- "Scotland"

#write OOWB count to csv
write.csv(oowb_proportions, "data_update/data/out_of_work_benefits_cpp_counts.csv", row.names = FALSE)

#read in denominator data (api output) and filter by years which API returns
population <- read.csv("data_update/data/working_age_population_cpp.csv") %>%
  filter(Year %in% unique(oowb_count$Year))

#combine numerator and denominator data and calculate proportion on benefits
oowb_proportions <- left_join(oowb_count, population, by = c("Year", "CPP")) %>%
  mutate(value = benefit_recipient_count_at_May/working_age_population*100,
         Indicator = "Out of Work Benefits",
         Type = "Raw") %>%
  select(CPP, Year, Indicator, Type, value) %>%
  arrange(CPP, Year)

write.csv(oowb_proportions, "data_update/data/out_of_work_benefits_cpp.csv", row.names = FALSE)
