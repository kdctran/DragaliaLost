library(shiny)
library(ggplot2)
library(tidyverse)


# user interface
ui <- fluidPage(
  titlePanel("Characters' Strength vs. HP"),
  
  sidebarLayout(
    sidebarPanel(
      
    )
  )
)


# server function
server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)