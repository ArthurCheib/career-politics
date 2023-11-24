## Function df_make_year()
# Description: for the files provided, it returns a dataset for a given year of choice

df_make_year <- function(files, year, save_file = FALSE, file_name = 'None', see_object = TRUE) {
  
  ## Select only the files for a given year of choice
  year_files <- all_files[str_detect(all_files, as.character(year))]
  
  ## Function to clean a given dataset and pile it for all given files
  data <- map_df(year_files, df_cleaner)
  
  if (save_file & file_name != 'None') {
    
    write_csv(data, here('clean-data', str_c(file_name, '.csv')))
    
  }
  
  ## If user still wants to see the object, then return the object
  if (see_object) {
    
    return(data)
    
  }

  
}

## Auxiliary function: df_cleaner()
# Description: this function opens a single dataset, transform each of its columns to be in the correct
#             data type is should be and returns a dataframe

df_cleaner <- function(file, register_date = TRUE) {
  
  ## Setting the working directory
  rd_file <- here('raw-data', file)
  
  ## Function that opens the dataset
  dataset <- read_delim(rd_file,
                        delim = ";",
                        col_types = cols(.default = col_character()),
                        locale = locale(decimal_mark = ","))
  
  ## In case it's not the expected standard n_cols = 35; then change how many reps to use
  if (ncol(dataset) != 35) {
    
    dt_types <- c('n', rep('c', 7), 'n', 'n', 'n', 'c', rep('n', 25))
    
  } else {
    
    dt_types <- c('n', rep('c', 7), 'n', 'n', 'n', 'c', rep('n', 23))
    
  }
  
  ## Function that coerce each of the columns in the dataset to its correct type
  clean_dataset <- map2_dfc(dataset, dt_types, ~ col_coercion(.x, .y))
  
  ## Adding new columns to the dataset
  if (register_date) {
    
    value_month <- as.numeric(sub(".*-(\\d+).csv$", "\\1", file))
    value_year <- as.numeric(sub("servidores-(\\d{4})-\\d{2}.csv$", "\\1", file))
    
    final_df <- clean_dataset |> 
      mutate(year = value_year,
             month = value_month)
    
  }
  
  ## Returns the cleaned dataframe
  return(final_df)
  
}

## Auxiliary function: col_coercion
# This function coerces a given column of dataframe into a different data type
col_coercion <- function(col, dt_type) {
  
  if (!is_vector(col)) {
    print('This function only works with vector')
    break
  } 
  
  ## Chooses which function to use depending on the coercion
  if (dt_type == 'c') {
    ## Char
    new_col <- as.character(col)
    
  } else if (dt_type == 'n') {
    ## Number
    new_col <- real_number(col)    
    
  } else {
    ## Logical
    new_col <- as.logical(col)    
    
  }
  
  return(new_col)
  
}

## Auxiliary function: real_number
# This function makes a real currency into a proper numeric type in R
real_number <- function(number_string) {
  
  # Replace thousands separator (periods) with nothing
  new_nstring <- gsub("\\.", "", number_string)
  
  # Replace decimal separator (comma) with a period
  final_nstring <- gsub(",", ".", new_nstring)
  
  # Convert to numeric
  numeric_value <- as.numeric(final_nstring)
  
  return(numeric_value)
  
}
