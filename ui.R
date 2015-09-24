library(shiny)
library(shinydashboard)
library(dygraphs)
options(scipen = 500)

#Header elements for the visualisation
header <- dashboardHeader(title = "Wikidata Metrics", disable = FALSE)

#Sidebar elements for the visualisations.
sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "stylesheet.css"),
    tags$script(src = "app-options.js")
  ),
  sidebarMenu(
    menuItem(text = "Engagement",
             menuSubItem(text = "Edits", tabName = "wikidata_edits"),
             menuSubItem(text = "Active Users", tabName = "wikidata_active_users"),
             menuSubItem(text = "Social Media", tabName = "wikidata_social_media"),
             menuSubItem(text = "Mailing Lists", tabName = "wikidata_mailing_lists")),
    menuItem(text = "Content",
             menuSubItem(text = "Pages", tabName = "wikidata_pages"),
             menuSubItem(text = "Items", tabName = "wikidata_items"),
             menuSubItem(text = "Properties", tabName = "wikidata_properties"),
             menuSubItem(text = "References", tabName = "wikidata_content_overview"),
             menuSubItem(text = "Referenced Statements by Type", tabName = "wikidata_content_refstmts"),
             menuSubItem(text = "References by Type", tabName = "wikidata_content_references"),
             menuSubItem(text = "Statement ranks", tabName = "wikidata_content_statement_ranks"),
             menuSubItem(text = "Statements per item", tabName = "wikidata_content_statement_item"),
             menuSubItem(text = "Labels per item", tabName = "wikidata_content_labels_item"),
             menuSubItem(text = "Descriptions per item", tabName = "wikidata_content_descriptions_item"),
             menuSubItem(text = "Wiki(m|p)edia links per item", tabName = "wikidata_content_wikilinks_item")),
    menuItem(text = "KPI",
             menuSubItem(text = "Community Health", tabName = "wikidata_community_health"),
             menuSubItem(text = "Quality", tabName = "wikidata_quality"),
             menuSubItem(text = "Partnerships", tabName = "wikidata_partnerships"),
             menuSubItem(text = "External Use", tabName = "wikidata_external_use"),
             menuSubItem(text = "Internal Use", tabName = "wikidata_internal_use"))

  )
)

#Body elements for the visualisations.
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "wikidata_edits",
            fluidRow(
              infoBoxOutput("editdelta")
            ),
            dygraphOutput("wikidata_edits_plot"),
            tags$br(),
            uiOutput("metric_meta_edits"),
            tags$br(),
            uiOutput("metric_meta_edits_notes")),
    tabItem(tabName = "wikidata_pages",
            dygraphOutput("wikidata_pages_plot")),
    tabItem(tabName = "wikidata_items",
            dygraphOutput("wikidata_content_items_plot")),
    tabItem(tabName = "wikidata_properties",
            dygraphOutput("wikidata_properties_plot")),
    tabItem(tabName = "wikidata_active_users",
            dygraphOutput("wikidata_active_users_plot"),
            tags$br(),
            uiOutput("metric_meta_active_users"),
            tags$br(),
            uiOutput("metric_meta_active_users_notes")),
    tabItem(tabName = "wikidata_social_media",
            dygraphOutput("wikidata_social_media_plot"),
            tags$br(),
            htmlOutput("legend_social_media")),
    tabItem(tabName = "wikidata_mailing_lists",
            dygraphOutput("wikidata_mailing_lists_plot"),
            tags$br(),
            htmlOutput("legend_lists")),
    tabItem(tabName = "wikidata_content_overview",
            dygraphOutput("wikidata_content_overview_plot"),
            htmlOutput("legend")),
    tabItem(tabName = "wikidata_content_refstmts",
            dygraphOutput("wikidata_content_refstmts_plot"),
            htmlOutput("legend_refstmts"),
            dygraphOutput("wikidata_content_refstmts_wikipedia_plot"),
            htmlOutput("legend_refstmts_wikipedia"),
            dygraphOutput("wikidata_content_refstmts_other_plot"),
            htmlOutput("legend_refstmts_other")),
    tabItem(tabName = "wikidata_content_references",
            dygraphOutput("wikidata_content_references_plot"),
            htmlOutput("legend_references")),
    tabItem(tabName = "wikidata_content_statement_ranks",
            dygraphOutput("wikidata_content_statement_ranks_plot"),
            htmlOutput("legend_statement_ranks")),
    tabItem(tabName = "wikidata_content_statement_item",
            dygraphOutput("wikidata_content_statement_item_plot"),
            htmlOutput("legend_statement_item")),
    tabItem(tabName = "wikidata_content_labels_item",
            dygraphOutput("wikidata_content_labels_item_plot"),
            htmlOutput("legend_labels_item")),
    tabItem(tabName = "wikidata_content_descriptions_item",
            dygraphOutput("wikidata_content_descriptions_item_plot"),
            htmlOutput("legend_descriptions_item")),
    tabItem(tabName = "wikidata_content_wikilinks_item",
            dygraphOutput("wikidata_content_wikilinks_item_plot"),
            htmlOutput("legend_wikilinks_item")),
    tabItem(tabName = "wikidata_community_health",
            tags$br(),
            fluidRow(column(width = 6,
              uiOutput("metric_meta_community_health")
            ))),
    tabItem(tabName = "wikidata_quality",
            tags$br(),
            fluidRow(column(width = 6,
            uiOutput("metric_meta_quality1"),
            tags$br(),
            uiOutput("metric_meta_quality2")))),
    tabItem(tabName = "wikidata_partnerships",
            tags$br(),
            fluidRow(
              infoBoxOutput("metric_meta_partnerships")
            )),
    tabItem(tabName = "wikidata_external_use",
            tags$br(),
            fluidRow(
              infoBoxOutput("metric_meta_external_use")
            )),
    tabItem(tabName = "wikidata_internal_use",
            fluidRow(
              uiOutput("metric_meta_internal_use_objects1")
            ),
            tags$br(),
            fluidRow(
              uiOutput("metric_meta_internal_use1")
            ),
            tags$br(),
            fluidRow(
              uiOutput("metric_meta_internal_use_objects2")
            ),
            tags$br(),
            fluidRow(
              uiOutput("metric_meta_internal_use2")
            ))
    )
)

dashboardPage(header, sidebar, body, skin = "blue")
