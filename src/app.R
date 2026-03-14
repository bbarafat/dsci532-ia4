library(shiny)
library(dplyr)
library(ggplot2)

data <- read_csv("../data/close.csv")

data_long <- data |>
  pivot_longer(
    cols = -date,
    names_to = "ticker",
    values_to = "price"
  )

ui <- fluidPage(
  titlePanel("Finance bros lite"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputID = "stock",
        label = "Choose a stock",
        choices = c("AAPL", "META","MSFT","GOOGL","NVDA","TSLA")
      )
    ),
    mainPanel(
      plotOutput("Price chart")
    )
  )
)

server <- function(input, output, session){
  selection <- input$stock
  filtered_data <- reactive({
    data_long |> filter(ticker == input$stock)
    
  })
  
  output$price_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = date, y = close)) +
      geom_line()+
      labs(
        title = paste("Price for", input$stock),
        x = "Date",
        y = "Close Price"
      )
  })
}

shinyApp(ui, server)