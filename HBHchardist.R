library(googlesheets)
library(tidyverse)
library(ggplot2)

my_sheets <- gs_ls() #get list of google sheet in my account
be <- gs_title("Dragalia Lost - HBH Character Distribution")
gs_ws_ls(be)
hbh <- gs_read(ss=be, ws = "Sheet1", skip=0)

hbh <- hbh %>%
  mutate(Class = ifelse(Character == "Thaniel" | Character == "Ricardt",
                        "Heal",
                        ifelse(Character == "Xainfried" | Character == "Elisanne", 
                               "Support", "DPS")))

hbh <- within(hbh, 
              Class <- factor(Class, 
                              levels=names(sort(table(Class), decreasing=TRUE))))
hbh <- within(hbh, 
              Character <- factor(Character, 
                              levels=names(sort(table(Character), decreasing=FALSE))))

# Summarizing
# Date count
hbh_bydate <- hbh %>% 
  group_by(Date) %>%
  summarise(n = n()) 
hbh_bydate

# Character count
hbh_count <- hbh %>% 
  group_by(Class, Character) %>%
  summarise(n = n()) %>%
  ungroup()
hbh_count

# stacked bar 
ggplot(hbh_count, aes(x = Class, y = n, fill = Character)) + 
  geom_bar(stat = "identity", position = "stack") +
  geom_text(aes(label = paste0(Character, " (", n, ")")), 
            size = 4,
            fontface = "bold",
            position = position_stack(vjust = 0.5, reverse = FALSE)) +
  scale_fill_manual(values = c("Thaniel" = "green2", "Ricardt" = "olivedrab3",
                               "Lily" = "red2", "Orsem" = "firebrick1",
                               "Xainfried" = "purple3", "Elisanne" = "darkorchid1")) +
  theme(legend.position="none")

ggplot(hbh) + 
  geom_bar(mapping = aes(x = Character, fill = Character))

