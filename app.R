library(shiny)
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(plotly)
library(zoo)

data_long <- read_csv("../data/close.csv") |>
  pivot_longer(
    cols = -Date,
    names_to = "ticker",
    values_to = "price"
  ) |>
  rename(date = Date) |>
  mutate(date = as.Date(date))

ui <- fluidPage(
  titlePanel("Stock Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "stock",
        label = "Choose a stock",
        choices = c(
          "All stocks" = "ALL",
          "Apple" = "AAPL",
          "Microsoft" = "MSFT",
          "Google" = "GOOGL",
          "Amazon" = "AMZN",
          "Meta" = "META",
          "NVIDIA" = "NVDA",
          "Tesla" = "TSLA"
        ),
        selected = "ALL"
      ),
      
      sliderInput(
        inputId = "roll_window",
        label = "Rolling average window",
        min = 5,
        max = 60,
        value = 20,
        step = 5
      )
    ),
    
    mainPanel(
      plotOutput("stock_plot", height = "400px"),
      br(),
      plotlyOutput("rolling_avg_plot", height = "450px")
    )
  )
)

server <- function(input, output, session) {
  
  filtered_data <- reactive({
    if (input$stock == "ALL") {
      data_long
    } else {
      data_long |>
        filter(ticker == input$stock)
    }
  })
  
  output$stock_plot <- renderPlot({
    ggplot(filtered_data(), aes(x = date, y = price, color = ticker, group = ticker)) +
      geom_line() +
      labs(
        title = if (input$stock == "ALL") "All Stocks" else paste("Price for", input$stock),
        x = "Date",
        y = "Close Price"
      ) +
      theme_minimal()
  })
  
  rolling_data <- reactive({
    k <- input$roll_window
    
    data_long |>
      group_by(ticker) |>
      arrange(date, .by_group = TRUE) |>
      mutate(
        rolling_avg = zoo::rollmean(price, k = k, fill = NA, align = "right")
      ) |>
      ungroup() |>
      filter(!is.na(rolling_avg))
  })
  
  output$rolling_avg_plot <- renderPlotly({
    plot_data <- rolling_data()
    
    plot_ly(
      data = plot_data,
      x = ~date,
      y = ~rolling_avg,
      color = ~ticker,
      type = "scatter",
      mode = "lines",
      hovertemplate = paste(
        "Ticker: %{fullData.name}<br>",
        "Date: %{x}<br>",
        "Rolling Avg: %{y:.2f}<extra></extra>"
      )
    ) |>
      layout(
        title = paste(input$roll_window, "-Day Rolling Average for All Stocks"),
        xaxis = list(title = "Date"),
        yaxis = list(title = "Rolling Average Price")
      )
  })
}

shinyApp(ui, server)