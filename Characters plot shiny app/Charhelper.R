library(googlesheets)
library(tidyverse)
library(ggplot2)
library(reshape2)

my_sheets <- gs_ls() #get list of google sheet in my account
be <- gs_title("Characters")
gs_ws_ls(be)
char <- gs_read(ss=be, ws = "Sheet1", skip=0)

path <- getwd()

write_rds(char, path = paste0(path, "/Characters plot shiny app/characterlist.rds"))

p <- char %>%
  ggplot() +
  geom_point(aes(HP, STR, colour = Element), size = 3) +
  scale_color_manual(values = c("Flame" = "red2", 
                                "Water" = "dodgerblue1",
                                "Wind" = "green",
                                "Light" = "gold",
                                "Shadow" = "purple")) +
  theme_bw() + 
  theme(panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

# p + geom_abline(slope = 1, intercept = 0) +
#   lims(x = c(600,850), y = c(390,750))

