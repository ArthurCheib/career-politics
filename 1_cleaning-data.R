## Libraries
library(tidyverse)
library(lubridate)
library(here)
library(janitor)
source(here('functions', 'unique_rows.R'))
source(here('functions', 'df_make_year.R'))

## Having check the data:
# Goal: have all columns from all tables with the same data type
# Steps:
# 1- Go through each column for each table and get the unique values - check what they look like

## Step 1: start dividing the tables
all_files <- list.files(here('raw-data'), '.csv')

## TB_SERVIDOR
# This table contains the unique identifier and the name for each 'servidor'
tb_servidor <- unique_rows(list_files = all_files,
                           col_name = c('masp', 'nome'),
                           col_type = c('n', 'c'),
                           add_rem_col = FALSE) |> 
  arrange(masp) %>%
  filter(!str_detect(nome, regex("judicial|jucicial", ignore_case = TRUE)))

write_csv(x = tb_servidor, file = here('clean-data', 'tb_servidor.csv'))
    
## TB_CARREIRA
# This table contains all the unique 'cargo da carreira' of each public servant
tb_carreira <- unique_rows(list_files = all_files,
                           col_name = c('nmefet'),
                           col_type = c('c'),
                           add_rem_col = FALSE) |> 
  arrange(nmefet)

write_csv(x = tb_carreira, file = here('clean-data', 'tb_carreira.csv'))

## Creating a dataset for a given year
servidores <- df_make_year(all_files,
                           year = 2021,
                           save_file = TRUE,
                           file_name = 'servidores_2021',
                           see_object = TRUE)
