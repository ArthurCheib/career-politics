## Function make_df_career()
# Description: this function builds a dataset for a given career for chosen years
# Dependencies
library(tidyverse)
library(here)

# Function
make_df_career <- function(career, years) {
  
  ## Extract the career info
  data <- map2_df(career, years, get_career)
  
}

## Auxiliary function: get_career
# This function gets the career for a given dataset
get_career <- function(career, year) {
  
  ## Constructs the name of the file using the year info
  year_file <- str_c('servidores_', year, '.csv')
  
  ## Open the dataset for a given year
  df <- read_csv(here('clean-data', year_file)) |> 
    filter(nmefet == career)
  
  return(df)
  
}
