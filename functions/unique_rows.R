## Function: unique_rows
# Description: this function collects the unique information for a given column for all tables

# Dependencies
library(tidyverse)

# Function
unique_rows <- function(list_files, col_name, col_type, add_rem_col = FALSE) {
  
  if (add_rem_col) {
    
    ## Adjusting the filenames
    new_names <- str_remove(list_files, 'servidores-')
    new_names <- str_remove(new_names, '\\.csv')
    
    ## Extracting the col and adding new column
    data <- map2_df(list_files, new_names, ~{
      
      df <- read_csv2(here::here('raw-data', .x),
                      locale = locale(decimal_mark = ",", grouping_mark = "."),
                      col_select = col_name, col_types = col_type)
      df <- mutate(df, rem_file = .y)
      return(df)
      
    })
    
    uniques <- data |> 
      select(all_of(col_name), rem_file) |> 
      distinct()
    
    return(uniques)
    
  } else {
    
    ## Extracting the col and adding new column
    data <- map_df(list_files, ~{
      df <- read_csv2(here::here('raw-data', .x),
                      locale = locale(decimal_mark = ",", grouping_mark = "."),
                      col_select = col_name, col_types = col_type)
      
      return(df)
      
    })
    
    uniques <- data |> 
      select(all_of(col_name)) |> 
      distinct()
    
    return(uniques)
    
  }
  
 
}