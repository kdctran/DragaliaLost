library(shiny)
library(ggplot2)
library(tidyverse)

charlist <- read_rds("characterlist.rds")

# user interface
ui <- fluidPage(
  # title
  titlePanel("Dragalia Lost - Characters' Strength vs. HP"),
  
  # sidebar
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "Element", 
                  label = "Select an Element",
                  choices = c("All", distinct(charlist, Element)),
                  selected = NULL,
                  multiple = F),
      
      selectInput(inputId = "method", 
                  selected = NULL,
                  label = "Select a weapon Type",
                  choices = c("All", distinct(charlist, Weapon))),
      
      selectInput(inputId = "method", 
                  selected = NULL,
                  label = "Select a Class",
                  choices = c("All", distinct(charlist, Class))),
      width = 2
    ),
    
    # main panel
    mainPanel(
      plotOutput(outputId = "charPlot")
    )
  )
)


# server function
server <- function(input, output) {
  output$charPlot <- renderPlot({
    
    # filter by element
    charfilter <- charlist %>%
      filter(if (input$Element != "All") {
               Element == input$Element
             } else TRUE) %>%
      filter(if (input$Weapon != "All") {
        Element == input$Weapon
      } else TRUE) %>%
      filter(if (input$Class != "All") {
        Element == input$Class
      } else TRUE)
    
    charfilter %>%
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
  }
    
  )
}

# run the application 
shinyApp(ui = ui, server = server)