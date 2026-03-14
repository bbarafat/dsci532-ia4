library(shiny)
library(dplyr)
library(ggplot2)

data <- read_csv("..data/close.csv")

ui <- fluidPage(
  titlePanel("Finance bros lite"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputID = "stock",
        label = "Choose a stock",
        choices = c("Apple", "Meta","Microsoft","Google","Nvidia","Tesla")
      )
    ),
    mainPanel(
      plotOutput("Price chart")
    )
  )
)

