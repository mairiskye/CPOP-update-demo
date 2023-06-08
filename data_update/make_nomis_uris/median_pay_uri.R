library(nomisr) #helper package
library(magrittr) #for piping

#search metadata for API Reference from webpage and extract dataset ID
dataset_id <- nomisr::nomis_search("ASHE") %>% pull(id)

metadata <- nomisr::nomis_get_metadata(dataset_id)

item <- nomisr::nomis_get_metadata(dataset_id, concept = "ITEM") %>%
  filter(grepl("Median", description.en)) %>%
  pull(id)

pay <- nomisr::nomis_get_metadata(dataset_id, concept = "PAY") %>%
  filter(grepl("Weekly pay - gross", description.en)) %>%
  pull(id)

sex <- nomisr::nomis_get_metadata(dataset_id, concept = "sex") %>%
  filter(grepl("Total", description.en)) %>%
  pull(id)

geography_type <- nomisr::nomis_get_metadata(dataset_id, concept = "GEOGRAPHY", type = "TYPE") %>%
  filter(grepl("local authorities: district", description.en)) %>%
  filter(grepl("2021", description.en)) %>%
  pull(id)

geography_area <- nomisr::nomis_get_metadata(dataset_id, concept = "GEOGRAPHY", type = geography_type) %>%
  filter(grepl("Falkirk", description.en)) %>%
  pull(parentCode)

uri <- paste0("https://www.nomisweb.co.uk/api/v01/dataset/",
              dataset_id,
              ".data.csv?geography=",
              geography_area,
              geography_type,
              "&item=",
              item,
              "&pay=",
              pay,
              "sex=",
              sex,
              "measures=20100&time=2008,latest&select=,DATE_NAME,GEOGRAPHY_NAME,OBS_VALUE")