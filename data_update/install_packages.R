library(magrittr)

packages <- c("dplyr", "httr", "magrittr", "readr", "statxplorer",
              "stringr", "zoo", "phsopendata", "tidyr", "onsr",
              "jsonlite", "nomisr", "ggplot2", "plotly", "shiny", 
              "shinydashboard", "renv")

#function to check if package from list is installed, if not then install.
check_and_install <- function(pkg){
  new_pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new_pkg)) 
    install.packages(new_pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

#apply function to package dependencies
ipak(packages)
