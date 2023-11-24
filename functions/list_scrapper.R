## Function: list_scrapper
# Description: this function finds the list contained within the table in the URL where
# all the data on "Remuneracao dos Servidores" is located.

# Dependencies
library(tidyverse)
library(rvest)
library(jsonlite)

# Function
list_scrapper <- function(url) {
  
  ## Gets the URL
  webpage <- read_html(url)
  
  ## Get the table
  tables <- html_table(webpage)
  
  ## Check if the cell where the information searched is available
  right_cell <- 'resources_ids'
  
  if (right_cell %in% tables[[1]]$Campo) {
    
    cell_position <- which(tables[[1]]$Campo %in% right_cell)
    
    ## Obtaining the table
    cell_data <- tables[[1]]['Valor'][[1]][[cell_position]]
    
    ## Converting from json to proper list format (parsing)
    clean_cell_data <- gsub('\\\\', '', cell_data)
    parsed_data <- fromJSON(clean_cell_data)
    
    ## Keep only the elements in the list that are 'servidores' files
    final_list <- parsed_data[str_detect(names(parsed_data), 'servidores')]

  } else {
    
    print('This cell does not seem to exist in the table anymore')
    
  }
  
  
  ## Returns the table information
  return(final_list)
  
}
              