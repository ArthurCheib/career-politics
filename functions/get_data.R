## Function: download_gz
# Description: this function can be used to download .gz files of 'Remuneracao Servidores Ativos'
# from the dados.mg.gov.br and store it in a folder of choice

# Dependencies
library(tidyverse)
library(here)
library(curl)
library(tools)

# use case: download_gz(key = 'my_key', value = 'value')

download_gz <- function(key, value) {
  
  ## String combining the URL
  url <- str_c('https://dados.mg.gov.br/dataset/98b58ea9-813e-4f50-8555-4ec0e15bbe91/resource/',
               value,
               '/download/',
               key,
               '.csv.gz')
  
  ## Establishing the destination of both the file to be download + the csv to be extracted
  local_gz_file <- here('raw-data', str_c(key, '.csv.gz'))
  local_csv_file <- here('raw-data', str_c(key, '.csv'))
  
  # Downloading the .gz file
  curl_download(url, destfile = local_gz_file, mode = 'wb')
  
  # Unzip the file using a system command + removing it!
  system2("gunzip", args = local_gz_file)

}

