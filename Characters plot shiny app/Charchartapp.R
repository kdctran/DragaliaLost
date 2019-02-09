library(shiny)
library(plotly)
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
      
      selectInput(inputId = "Weapon", 
                  selected = NULL,
                  label = "Select a Weapon Type",
                  choices = c("All", distinct(charlist, Weapon))),
      
      selectInput(inputId = "Class", 
                  selected = NULL,
                  label = "Select a Class",
                  choices = c("All", distinct(charlist, Class))),
      width = 2
    ),
    
    # main panel
    mainPanel(
      # plotly instead of plot because using Plotly package
      plotlyOutput(outputId = "charPlot")
    )
  )
)


# server function
server <- function(input, output) {
  output$charPlot <- renderPlotly({
    
    # filter by element/weapon/class
    p <- charlist %>%
      filter(if (input$Element != "All") {
               Element == input$Element
             } else TRUE) %>%
      filter(if (input$Weapon != "All") {
        Element == input$Weapon
      } else TRUE) %>%
      filter(if (input$Class != "All") {
        Element == input$Class
      } else TRUE)
    
    # plot with ggplot & plotly
    p <- p %>%
      ggplot(aes(x = HP, y = STR, colour = Element,
                 label = Name,
                 label2 = HP,
                 label3 = STR,
                 label4 = Weapon)) +
      geom_point(size = 2) +
      scale_color_manual(values = c("Flame" = "red2", 
                                    "Water" = "dodgerblue1",
                                    "Wind" = "green",
                                    "Light" = "gold",
                                    "Shadow" = "purple")) +
      theme_bw() + 
      theme(panel.border = element_blank(), 
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(), 
            axis.line = element_line(colour = "black")) +
      
      # reference y = x line
      geom_abline(slope = 1, intercept = 0)
    
    # format legend box
    legend.format <- list(
      font = list(
        family = "sans-serif",
        size = 12,
        color = "black"),
      bgcolor = "gainsboro",
      bordercolor = "white",
      borderwidth = 2)
    
    p <- ggplotly(p, tooltip = c("label", "label2", "label3", "label4")) %>%
      # hide plotly mode bar
      config(displayModeBar = F) %>% 
      layout(legend = legend.format)
    p
  }
   
  )
}

# run the application 
shinyApp(ui = ui, server = server)