library(shiny)
library(plotly)
library(tidyverse)
library(DT)

charlist <- read_rds("character_gsheet.rds")

# user interface
ui <- fluidPage(
  # title
  titlePanel("Dragalia Lost - Characters' Strength vs. HP"),
  titlePanel(h6("Data taken from Dragalia Lost gamepedia site")),
  
  # sidebar
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput(inputId = "Rarity", label = h3("Select Rarity"), 
                         choices = c(3, 4, 5),
                         selected = c(3, 4, 5)),
      
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
      plotlyOutput(outputId = "charPlot", width = "60%"),
      tableOutput(outputId = "table")
    )
  )
)


server <- function(input, output) {
  
  # data <- reactive({
  #   data <- charlist
  #   return(data)
  # })
  # 
  output$charPlot <- renderPlotly({
    
    # functions for plotting and best fit equation
    # plot function
    plotbyele <- function(df){
      myplot <- ggplot(df, aes(x = HP, y = STR, colour = Element,
                               label = Name,
                               label2 = STR,
                               label3 = HP)) +
        geom_point(position = position_jitter(h = 2, w = 2),
                   size = 2) +
        scale_color_manual(values = c("Flame" = "red2", 
                                      "Water" = "dodgerblue1",
                                      "Wind" = "green",
                                      "Light" = "gold",
                                      "Shadow" = "purple")) +
        theme_bw() + 
        theme(panel.border = element_blank(), 
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(), 
              axis.line = element_line(colour = "black"))
      
      # return plot
      myplot
    }
    
    # plot by star rarity
    plotbystar <- function(df){
      myplot <- ggplot(df, aes(x = HP, y = STR,
                               label = Name,
                               label2 = STR,
                               label3 = HP)) +
        geom_point(aes(fill = factor(Rarity)),
                   position = position_jitter(h = 1, w = 1),
                   size = 2,
                   stroke = 0.1) +
        scale_fill_manual(name = "Rarity",
                          labels = c("3 Star","4 Star","5 Star"),
                          values = c("blue", "yellow1", "red"),
                          drop = F) +
        theme_bw() + 
        theme(panel.border = element_blank(), 
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(), 
              axis.line = element_line(colour = "black")) 
      
      # return plot
      myplot
    }
    
    # filter by element/weapon/class
    validate(
      need(input$Rarity, "Select at least 1 Rarity")
    )
    
    data <- charlist %>%
      filter(Rarity %in% input$Rarity)

    if (input$Element != "All") {
      data <- data %>%
        filter(Element == input$Element)
    }
    if (input$Weapon != "All") {
      data <- data %>%
        filter(Weapon == input$Weapon)
    }
    if (input$Class != "All") {
      data <- data %>%
        filter(Class == input$Class)
    }
    
    # best fit line
    m <- lm(data$STR ~ data$HP)
    intercept <- signif(coef(m)[1], digits = 2)
    slope <- signif(coef(m)[2], digits = 2)
    textlab <- paste("STR = ", slope, "HP + ", intercept, sep = "")
    
    # filter for best fit line
    # if ((input$Weapon != "All") & (input$Class != "All")) {
    #   
    # }
    
    legend.format <- list(font = list(family = "sans-serif",
                                      size = 12,
                                      color = "black"),
                          bgcolor = "lavender",
                          bordercolor = "white",
                          borderwidth = 3)
    
    p <- plotbystar(data)
    
    p <- p + geom_abline(intercept = intercept, slope = slope,
                         colour = "grey30", linetype = "dashed",
                         size = 0.3)
    
    # coord to display equation
    display.x <- (max(data$HP) + min(data$HP)) / 2
    display.y <- max(data$STR) + 10
    
    # add regression equation using annotate
    p <- p + annotate("text", x = display.x, y = display.y,
                      label = textlab,
                      color="black", size = 4)
    
    p <- ggplotly(p, tooltip = c("label", "label2", "label3", "label4")) %>%
      # hide plotly mode bar
      config(displayModeBar = F) %>% 
      layout(legend = legend.format)
    p
  })
  
  output$table <- renderTable({
    
    validate(
      need(input$Rarity, "Select at least 1 Rarity")
    )
    
    data <- charlist %>%
      filter(Rarity %in% input$Rarity)

    if (input$Element != "All") {
      data <- data %>%
        filter(Element == input$Element)
    }
    if (input$Weapon != "All") {
      data <- data %>%
        filter(Weapon == input$Weapon)
    }
    if (input$Class != "All") {
      data <- data %>%
        filter(Class == input$Class)
    }
    
    data
  })
}

# run the application 
shinyApp(ui = ui, server = server)

#################
# to deploy app:
# 1. rsconnect
# 2. get token, then setAccountInfo
# library(rsconnect)
# deployApp("C:/Users/User/Documents/Dragalia Lost/Characters plot shiny app")

