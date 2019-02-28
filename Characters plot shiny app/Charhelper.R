library(googlesheets)
library(tidyverse)
library(plotly)

my_sheets <- gs_ls() #get list of google sheet in my account
be <- gs_title("Characters")
gs_ws_ls(be)
char <- gs_read(ss=be, ws = "Sheet1", skip=0)

path <- getwd()

write_rds(char, path = paste0(path, "/Characters plot shiny app/characterlist.rds"))

# plotdl <- function(data){
#   myplot <- ggplot(data, aes(x = HP, y = STR, colour = Element,
#              label = Name,
#              label2 = STR,
#              label3 = HP,
#              label4 = Weapon)) +
#   geom_point(size = 3) +
#   scale_color_manual(values = c("Flame" = "red2", 
#                                 "Water" = "dodgerblue1",
#                                 "Wind" = "green",
#                                 "Light" = "gold",
#                                 "Shadow" = "purple")) +
#   theme_bw() + 
#   theme(panel.border = element_blank(), 
#         panel.grid.major = element_blank(),
#         panel.grid.minor = element_blank(), 
#         axis.line = element_line(colour = "black"))
#   
#   # return plot
#   myplot
# }
# 
# legend.format <- list(font = list(family = "sans-serif",
#                                   size = 12,
#                                   color = "black"),
#                       bgcolor = "lavender",
#                       bordercolor = "white",
#                       borderwidth = 2)

# p2 <- char %>%
#   filter(Weapon == "Staff") %>%
#   ggplot(aes(x = HP, y = STR,
#              label = Name,
#              label2 = STR,
#              label3 = HP,
#              label4 = Weapon)) +
#   geom_point(aes(colour = Element), size = 3) +
#   scale_color_manual(values = c("Flame" = "red2", 
#                                 "Water" = "dodgerblue1",
#                                 "Wind" = "green",
#                                 "Light" = "gold",
#                                 "Shadow" = "purple")) +
#   geom_smooth(aes(x = HP, y = STR), inherit.aes = F, se = F,
#               method = "lm", 
#               formula = y ~ x, 
#               colour = "black")
# p2
# 
# legend.format <- list(font = list(family = "sans-serif",
#                                   size = 12,
#                                   color = "black"),
#                       bgcolor = "gainsboro",
#                       bordercolor = "white",
#                       borderwidth = 2)
# 
# p <- ggplotly(p, tooltip = c("label", "label2", "label3", "label4")) %>%
#   layout(legend = legend.format)
# p
# # p + geom_abline(slope = 1, intercept = 0) +
# #   lims(x = c(600,850), y = c(390,750))
# 


