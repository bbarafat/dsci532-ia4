library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)
library(gapminder)

# ── Data ──────────────────────────────────────────────────────────────────────

data <- gapminder::gapminder

continents <- sort(unique(data$continent))
years      <- sort(unique(data$year))

# ── UI ────────────────────────────────────────────────────────────────────────

ui <- page_sidebar(
  title = "Gapminder World Dashboard",
  theme = bs_theme(bootswatch = "flatly"),

  sidebar = sidebar(
    title = "Filters",
    checkboxGroupInput(
      "continents",
      "Continent",
      choices  = continents,
      selected = continents
    ),
    sliderInput(
      "year",
      "Year",
      min   = min(years),
      max   = max(years),
      value = max(years),
      step  = 5,
      sep   = ""
    )
  ),

  # Main content
  layout_columns(
    col_widths = c(8, 4),
    card(
      card_header("Life Expectancy vs GDP per Capita"),
      plotOutput("scatter_plot", height = "400px")
    ),
    card(
      card_header("Summary Statistics"),
      tableOutput("summary_table")
    )
  ),
  layout_columns(
    col_widths = c(6, 6),
    card(
      card_header("Life Expectancy by Continent"),
      plotOutput("boxplot", height = "350px")
    ),
    card(
      card_header("Population by Continent"),
      plotOutput("bar_chart", height = "350px")
    )
  )
)

# ── Server ────────────────────────────────────────────────────────────────────

server <- function(input, output, session) {

  filtered_data <- reactive({
    req(input$continents)
    data |>
      filter(
        continent %in% input$continents,
        year == input$year
      )
  })

  output$scatter_plot <- renderPlot({
    df <- filtered_data()
    validate(need(nrow(df) > 0, "No data available for the selected filters."))

    ggplot(df, aes(x = gdpPercap, y = lifeExp,
                   size = pop, colour = continent)) +
      geom_point(alpha = 0.7) +
      scale_x_log10(labels = scales::label_dollar()) +
      scale_size(range = c(2, 15), guide = "none") +
      labs(
        x      = "GDP per Capita (log scale)",
        y      = "Life Expectancy (years)",
        colour = "Continent"
      ) +
      theme_minimal(base_size = 13) +
      theme(legend.position = "bottom")
  })

  output$boxplot <- renderPlot({
    df <- filtered_data()
    validate(need(nrow(df) > 0, "No data available for the selected filters."))

    ggplot(df, aes(x = continent, y = lifeExp, fill = continent)) +
      geom_boxplot(alpha = 0.7, show.legend = FALSE) +
      labs(x = NULL, y = "Life Expectancy (years)") +
      theme_minimal(base_size = 13)
  })

  output$bar_chart <- renderPlot({
    df <- filtered_data()
    validate(need(nrow(df) > 0, "No data available for the selected filters."))

    df |>
      group_by(continent) |>
      summarise(total_pop = sum(pop) / 1e6, .groups = "drop") |>
      ggplot(aes(x = reorder(continent, -total_pop),
                 y = total_pop, fill = continent)) +
      geom_col(alpha = 0.8, show.legend = FALSE) +
      labs(x = NULL, y = "Total Population (millions)") +
      theme_minimal(base_size = 13)
  })

  output$summary_table <- renderTable({
    filtered_data() |>
      group_by(continent) |>
      summarise(
        Countries      = n(),
        `Avg Life Exp` = round(mean(lifeExp), 1),
        `Avg GDP/Cap`  = scales::label_comma(prefix = "$")(round(mean(gdpPercap), 0)),
        .groups        = "drop"
      )
  }, striped = TRUE, hover = TRUE, bordered = TRUE)
}

# ── Launch ────────────────────────────────────────────────────────────────────

shinyApp(ui = ui, server = server)
