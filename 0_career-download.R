## Libraries
library(tidyverse)
library(lubridate)
library(here)
source(here('functions', 'get_data.R'))

## Dictionary of the data (comprehensive list)
# Create a list with key-value pairs
servidor_url <- "https://dados.mg.gov.br/dataset/remuneracao-servidores-ativos"
urls_list <- list_scrapper(url = servidor_url)
current_files <- str_c(names(urls_list) |> sort(), '.csv')

# Compare the existing files with the previosly downloaded ones
downloaded_files <- list.files(here('raw-data'), pattern = 'servidores') |> sort()

# Extracting the name of the most recent downloaded and most recent uploaded files
last_downloaded <- downloaded_files[length(downloaded_files)]
recent_upload <- current_files[length(current_files)]

if (last_downloaded != recent_upload) {
  
  answer <- tolower(readline(prompt = 'You are not up-to-date. Do you want download missing files? '))
  
  if (answer == 'yes' | answer == 'y') {
    
    missing_files <- which(!current_files %in% downloaded_files)
    list_to_download <- urls_list[missing_files]
    
    ## Downloading the data
    map2(names(list_to_download), list_to_download, download_gz)
    
  } else {
    
    'Okay, I wont download it now. Let me know whenever you are ready!'
    
  }

} else {
  
  cat('You are up-to-date. Both yours and website last version is:', last_downloaded)
  
}


    