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
             menuSubItem(text = "Pages", tabName = "wikidata_pages"),
             menuSubItem(text = "Properties", tabName = "wikidata_properties"),
             menuSubItem(text = "Active Users", tabName = "wikidata_active_users"),
             menuSubItem(text = "Social Media", tabName = "wikidata_social_media"),
             menuSubItem(text = "Mailing Lists", tabName = "wikidata_mailing_lists")),
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
             menuSubItem(text = "Wiki(m|p)edia links per item", tabName = "wikidata_content_wikilinks_item"))
  )
)

#Body elements for the visualisations.
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "wikidata_edits",
            dygraphOutput("wikidata_edits_plot"),
            includeMarkdown("./assets/content/wikidata-edits.md")),
    tabItem(tabName = "wikidata_pages",
            dygraphOutput("wikidata_pages_plot"),
            includeMarkdown("./assets/content/wikidata-pages.md")),
    tabItem(tabName = "wikidata_properties",
            dygraphOutput("wikidata_properties_plot"),
            includeMarkdown("./assets/content/wikidata-properties.md")),
    tabItem(tabName = "wikidata_active_users",
            dygraphOutput("wikidata_active_users_plot"),
            includeMarkdown("./assets/content/wikidata-active-users.md")),
    tabItem(tabName = "wikidata_social_media",
            dygraphOutput("wikidata_social_media_plot"),
            tags$br(),
            htmlOutput("legend_social_media"),
            includeMarkdown("./assets/content/wikidata-social-media.md")),
    tabItem(tabName = "wikidata_mailing_lists",
            dygraphOutput("wikidata_mailing_lists_plot"),
            tags$br(),
            htmlOutput("legend_lists"),
            includeMarkdown("./assets/content/wikidata_mailing_lists.md")),
    tabItem(tabName = "wikidata_content_overview",
            dygraphOutput("wikidata_content_overview_plot"),
            htmlOutput("legend"),
            includeMarkdown("./assets/content/wikidata-content-overview.md")),
    tabItem(tabName = "wikidata_content_refstmts",
            dygraphOutput("wikidata_content_refstmts_plot"),
            htmlOutput("legend_refstmts"),
            includeMarkdown("./assets/content/wikidata-content-refstmts.md")),
    tabItem(tabName = "wikidata_content_refstmts_wikipedia",
            dygraphOutput("wikidata_content_refstmts_wikipedia_plot"),
            htmlOutput("legend_refstmts_wikipedia"),
            includeMarkdown("./assets/content/wikidata_content_refstmts_wikipedia.md")),
    tabItem(tabName = "wikidata_content_refstmts_other",
            dygraphOutput("wikidata_content_refstmts_other_plot"),
            htmlOutput("legend_refstmts_other"),
            includeMarkdown("./assets/content/wikidata_content_refstmts_other.md")),
    tabItem(tabName = "wikidata_content_references",
            dygraphOutput("wikidata_content_references_plot"),
            htmlOutput("legend_references"),
            includeMarkdown("./assets/content/wikidata_content_references.md")),
    tabItem(tabName = "wikidata_content_statement_ranks",
            dygraphOutput("wikidata_content_statement_ranks_plot"),
            htmlOutput("legend_statement_ranks"),
            includeMarkdown("./assets/content/wikidata_content_statement_ranks.md")),
    tabItem(tabName = "wikidata_content_statement_item",
            dygraphOutput("wikidata_content_statement_item_plot"),
            htmlOutput("legend_statement_item"),
            includeMarkdown("./assets/content/wikidata_content_statement_item.md")),
    tabItem(tabName = "wikidata_content_labels_item",
            dygraphOutput("wikidata_content_labels_item_plot"),
            htmlOutput("legend_labels_item"),
            includeMarkdown("./assets/content/wikidata_content_labels_item.md")),
    tabItem(tabName = "wikidata_content_descriptions_item",
            dygraphOutput("wikidata_content_descriptions_item_plot"),
            htmlOutput("legend_descriptions_item"),
            includeMarkdown("./assets/content/wikidata_content_descriptions_item.md")),
    tabItem(tabName = "wikidata_content_wikilinks_item",
            dygraphOutput("wikidata_content_wikilinks_item_plot"),
            htmlOutput("legend_wikilinks_item"),
            includeMarkdown("./assets/content/wikidata_content_wikilinks_item.md"))
  )
)

dashboardPage(header, sidebar, body, skin = "blue")
