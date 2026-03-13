# dsci532-ia4 — Gapminder World Dashboard

An interactive R Shiny dashboard exploring global trends in life expectancy, GDP per capita, and population using the [Gapminder](https://www.gapminder.org/) dataset.

## Features

- **Scatter plot** — Life expectancy vs. GDP per capita (log scale), bubbles scaled by population
- **Box plot** — Distribution of life expectancy across continents
- **Bar chart** — Total population by continent
- **Summary table** — Key statistics per continent
- **Filters** — Continent checkboxes and a year slider (1952–2007)

## Requirements

Install the required R packages before running locally:

```r
install.packages(c("shiny", "bslib", "ggplot2", "dplyr", "gapminder", "scales"))
```

## Running Locally

```r
shiny::runApp("app.R")
```

Or open `app.R` in RStudio and click **Run App**.

## Deployment on Posit Cloud

1. Log in to [Posit Cloud](https://posit.cloud/).
2. Create a new **Shiny** project and upload `app.R` (or connect this GitHub repository).
3. Posit Cloud will automatically install the required packages on first run.

Alternatively, deploy to [shinyapps.io](https://www.shinyapps.io/) using `rsconnect`:

```r
install.packages("rsconnect")
rsconnect::deployApp()
```
