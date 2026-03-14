## Overview

This project presents an interactive Stock Dashboard built using R Shiny. The dashboard allows users to explore historical stock prices and rolling averages for a selection of major technology companies.

The application provides interactive controls that allow users to:
- Select an individual stock ticker to visualize its historical closing price
- View the price trends of all stocks simultaneously
- Adjust the rolling average window to analyze smoothed trends across all stocks

The goal of this dashboard is to provide a simple and intuitive tool for exploring time-series stock data and understanding how rolling averages can highlight underlying trends in financial data.

⸻

## Features

The dashboard contains two main visualizations:

1. Stock Price Plot
- Displays historical closing prices.
- Users can select a specific stock or view all stocks.
- Implemented using ggplot2.

2. Rolling Average Plot
- Displays rolling average price trends for all stocks.
- The rolling window can be adjusted using a slider input.
- Implemented using Plotly for interactive exploration.

⸻

## Data

The dataset contains historical daily closing prices for several major technology companies:
- Apple (AAPL)
- Microsoft (MSFT)
- Google (GOOGL)
- Amazon (AMZN)
- Meta (META)
- NVIDIA (NVDA)
- Tesla (TSLA)

The data is stored in:
- `data/close.csv`: Contains historical stock price data.

## Deployed App

The dashboard is deployed and publicly accessible here: `https://019cea65-a247-9335-064e-bec051b7549d.share.connect.posit.cloud/`

## Installation

To run this app locally, you need R (≥ 4.0) and the following packages installed.

Install the required packages with:
```R
install.packages(c(
  "shiny",
  "tidyverse",
  "plotly",
  "zoo",
  "readr",
  "dplyr",
  "tidyr",
  "ggplot2"
))
```

## Running the App Locally

1.	Clone the repository:
```bash
git clone https://github.com/bbarafat/dsci532-ia4.git
```

2.	Open the project in RStudio.

3. Run the Shiny app by executing the following command in the R console:
```R
shiny::runApp("app.R")
```
or open `app.R` and click the "Run App" button in RStudio.

## Repository Structure

```
dsci532-ia4/
│
├── README.md
├── data/
│   └── close.csv
├── src/
│   └── app.R
└── .gitignore
```