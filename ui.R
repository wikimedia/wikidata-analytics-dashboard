library(shiny)
library(shinydashboard)
library(dygraphs)
options(scipen = 500)

#Header elements for the visualisation
header <- dashboardHeader(title = "Wikidata Metrics", disable = FALSE)

#Sidebar elements for the search visualisations.
sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
    tags$script(src = "rainbow.js")
  ),
  sidebarMenu(
    menuItem(text = "Wikidata",
             menuSubItem(text = "Edits", tabName = "wikidata_edits"),
             menuSubItem(text = "Pages", tabName = "wikidata_pages"),
             menuSubItem(text = "Properties", tabName = "wikidata_properties")),
    selectInput(inputId = "smoothing_global", label = "Smoothing (Global Setting)", selectize = TRUE, selected = "day",
                choices = c("No Smoothing" = "day", "Moving Average" = "moving_avg",
                            "Weekly Median" = "week", "Monthly Median" = "month"))
  )
)

# Standardised input selector for smoothing
smooth_select <- function(input_id, label = "Smoothing") {
  return(selectInput(inputId = input_id, label = label, selectize = TRUE,
                     selected = "global", choices = c("Use Global Setting" = "global",
                     "No Smoothing" = "day", "Moving Average" = "moving_avg",
                     "Weekly Median" = "week", "Monthly Median" = "month")))
}

#Body elements for the search visualisations.
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "wikidata_edits",
            smooth_select("smoothing_wikidata_edits"),
            dygraphOutput("wikidata_edits_plot"),
            includeMarkdown("./assets/content/wikidata-edits.md")),
    tabItem(tabName = "wikidata_pages",
            smooth_select("smoothing_wikidata_pages"),
            dygraphOutput("wikidata_pages_plot"),
            includeMarkdown("./assets/content/wikidata-pages.md")),
    tabItem(tabName = "wikidata_properties",
            smooth_select("smoothing_wikidata_properties"),
            dygraphOutput("wikidata_properties_plot"),
            includeMarkdown("./assets/content/wikidata-properties.md"))
  )
)

dashboardPage(header, sidebar, body, skin = "black")
