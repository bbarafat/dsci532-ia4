library(shiny)
library(dplyr)
library(ggplot2)

data <- read_csv("../data/close.csv")

data_long <- data |>
  pivot_longer(
    cols = -Date,
    names_to = "ticker",
    values_to = "price"
  )
data_long <- data_long |>
  mutate(Date = as.Date(Date))

ui <- fluidPage(
  titlePanel("Finance bros lite"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "stock",
        label = "Choose a stock",
        choices = c(
          "All stocks" = "ALL",
          "Apple" = "AAPL", 
          "Meta" = "META",
          "Microsoft" = "MSFT",
          "Google" = "GOOGL",
          "Nvidia"= "NVDA",
          "Tesla" = "TSLA"
          ),
        selected = "ALL"
      )
    ),
    mainPanel(
      plotOutput("price_chart")
    )
  )
)

server <- function(input, output, session){
  
  filtered_data <- reactive({
    if (input$stock == "ALL") {
      data_long
    } else {
      data_long |>
        filter(ticker == input$stock)
    }
    
  })
  
  output$price_chart <- renderPlot({
    plot_data <- filtered_data()
    ggplot(plot_data, aes(x = Date, y = price, group = ticker,color=ticker)) +
      geom_line()+
      labs(
        title = if (input$stock == "ALL") "All Stocks" else paste("Price for", input$stock),
        x = "Date",
        y = "Close Price"
      ) +
      theme_minimal()
  })
}

shinyApp(ui, server)