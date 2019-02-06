library(googlesheets)
library(tidyverse)
library(ggplot2)

my_sheets <- gs_ls() #get list of google sheet in my account
be <- gs_title("Characters")
gs_ws_ls(be)
char <- gs_read(ss=be, ws = "Sheet1", skip=0)

