library(googlesheets)
library(tidyverse)

my_sheets <- gs_ls() #get list of google sheet in my account
be <- gs_title("Characters_post_April2019_buff")
gs_ws_ls(be)
char <- gs_read(ss=be, ws = "Sheet1", skip=0)
char <- char %>%
  select(Name, Class, Rarity, Element, Weapon, HP, STR)

path <- getwd()

write_rds(char, path = paste0(path, "/Characters plot shiny app/character_gsheet.rds"))