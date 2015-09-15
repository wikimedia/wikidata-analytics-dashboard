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
    tags$script(src = "app-options.js")
  ),
  sidebarMenu(
    menuItem(text = "Engagement",
             menuSubItem(text = "Edits", tabName = "wikidata_edits"),
             menuSubItem(text = "Pages", tabName = "wikidata_pages"),
             menuSubItem(text = "Properties", tabName = "wikidata_properties"),
             menuSubItem(text = "Active Users", tabName = "wikidata_active_users"),
             menuSubItem(text = "Social Media", tabName = "wikidata_social_media")),
    menuItem(text = "Content",
             menuSubItem(text = "Overview", tabName = "wikidata_content_overview"),
             menuSubItem(text = "Referenced statements", tabName = "wikidata_content_refstmts"),
             menuSubItem(text = "Statement Refs to Wikipedia", tabName = "wikidata_content_refstmts_wikipedia"),
             menuSubItem(text = "Statement Refs to Other", tabName = "wikidata_content_refstmts_other"),
             menuSubItem(text = "References", tabName = "wikidata_content_references"),
             menuSubItem(text = "Statement ranks", tabName = "wikidata_content_statement_ranks"),
             menuSubItem(text = "Statements per item", tabName = "wikidata_content_statement_item"),
             menuSubItem(text = "Labels per item", tabName = "wikidata_content_labels_item"),
             menuSubItem(text = "Descriptions per item", tabName = "wikidata_content_descriptions_item"),
             menuSubItem(text = "Wiki(m|p)edia links per item", tabName = "wikidata_content_wiki-links_item")),
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
            includeMarkdown("./assets/content/wikidata-properties.md")),
    tabItem(tabName = "wikidata_active_users",
            smooth_select("smoothing_wikidata_active_users"),
            dygraphOutput("wikidata_active_users_plot"),
            includeMarkdown("./assets/content/wikidata-active-users.md")),
    tabItem(tabName = "wikidata_social_media",
            smooth_select("smoothing_wikidata_social_media"),
            dygraphOutput("wikidata_social_media_plot"),
            includeMarkdown("./assets/content/wikidata-social-media.md")),
    tabItem(tabName = "wikidata_content_overview",
            smooth_select("smoothing_wikidata_content_overview"),
            dygraphOutput("wikidata_content_overview_plot"),
            htmlOutput("legend"),
            includeMarkdown("./assets/content/wikidata-content-overview.md")),
    tabItem(tabName = "wikidata_content_refstmts",
            smooth_select("smoothing_wikidata_content_refstmts"),
            dygraphOutput("wikidata_content_refstmts_plot"),
            htmlOutput("legend_refstmts"),
            includeMarkdown("./assets/content/wikidata-content-refstmts.md")),
    tabItem(tabName = "wikidata_content_refstmts_wikipedia",
            smooth_select("smoothing_wikidata_content_refstmts_wikipedia"),
            dygraphOutput("wikidata_content_refstmts_wikipedia_plot"),
            htmlOutput("legend_refstmts_wikipedia"),
            includeMarkdown("./assets/content/wikidata-content-refstmts.md"))
  )
)

dashboardPage(header, sidebar, body, skin = "blue")
