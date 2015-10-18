#Header elements for the visualisation
header <- dashboardHeader(title = "Wikidata Metrics", disable = FALSE)

#Sidebar elements for the visualisations.
sidebar <- dashboardSidebar(
  tags$head(
    tags$script(src = "app-options.js"),
    tags$script(src = "app-events.js")
  ),
  sidebarMenu(
    id = "tabs",
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem(text = "", badgeLabel = "Recent", badgeColor = "green"),
    menuItem(text = "Frequency Stats", icon = icon("signal"),
             menuSubItem(text = "Edits/Day", tabName = "wikidata_daily_edits_delta"),
             menuSubItem(text = "New Pages/Day", tabName = "wikidata_daily_pages_delta"),
             menuSubItem(text = "New Active Users/Day", tabName = "wikidata_daily_users_delta")),
    menuItem(text = "Developer", icon = icon("gears"),
             menuSubItem(text = "getClaims Usage", tabName = "wikidata_daily_getclaims_property_use")),
#    menuItem(text = "Social Stats", icon = icon("heart"),
#             menuSubItem(text = "Networks", tabName = "wikidata_daily_social")),
    menuItem(text = "", badgeLabel = "Weekly RDF Stats", badgeColor = "red"),
    menuItem(text = "Queries", icon = icon("question"),
             menuSubItem(text = "Lists", tabName = "wikidata_rdf_queries")),
    menuItem(text = "", badgeLabel = "Monthly", badgeColor = "purple"),
    menuItem(text = "Engagement", icon = icon("eye"),
             menuSubItem(text = "Edits", tabName = "wikidata_edits"),
             menuSubItem(text = "Active Users", tabName = "wikidata_active_users"),
             menuSubItem(text = "Social Media", tabName = "wikidata_social_media"),
             menuSubItem(text = "Mailing Lists", tabName = "wikidata_mailing_lists")),
    menuItem(text = "Content", icon = icon("cubes"),
             menuSubItem(text = "Pages", tabName = "wikidata_pages"),
             menuSubItem(text = "Items", tabName = "wikidata_items"),
             menuSubItem(text = "Properties", tabName = "wikidata_properties"),
             menuSubItem(text = "References Overview", tabName = "wikidata_references_overview"),
             menuSubItem(text = "Referenced Statements by Type", tabName = "wikidata_content_refstmts"),
             menuSubItem(text = "References by Type", tabName = "wikidata_content_references"),
             menuSubItem(text = "Statement ranks", tabName = "wikidata_content_statement_ranks"),
             menuSubItem(text = "Statements per item", tabName = "wikidata_content_statement_item"),
             menuSubItem(text = "Labels per item", tabName = "wikidata_content_labels_item"),
             menuSubItem(text = "Descriptions per item", tabName = "wikidata_content_descriptions_item"),
             menuSubItem(text = "Wiki(m|p)edia links per item", tabName = "wikidata_content_wikilinks_item")),
     menuItem(text = "", badgeLabel = "Performance", badgeColor = "aqua"),
     menuItem(text = "KPI", icon = icon("trophy"),
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
    tabItem(tabName="dashboard",
            includeMarkdown("./assets/dashboard.md"),
            selectInput('switchtab', "Metric Selector", c("Home" = "dashboard", "Edits" = "wikidata_edits", "Pages" = "wikidata_pages", "Active Editors" = "wikidata_community_health")),
            DT::dataTableOutput("wikidata_daily_summary_table"),
            tags$br(),
            DT::dataTableOutput("wikidata_daily_datavalues_table")),
    tabItem(tabName = "wikidata_daily_edits_delta",
            dygraphOutput("wikidata_daily_edits_delta_plot"),
            tags$br(),
            htmlOutput("legend_daily_site"),
            checkboxInput("checkbox_total_edits", label = "Show total Edits", value = FALSE),
            tags$br(),
            fluidRow(
              uiOutput("metric_meta_recent_edits_seeAlso")
            ),
            tags$a(href="./?t=wikidata_daily_edits_delta", "Link here: ", icon("external-link"))),
    tabItem(tabName = "wikidata_daily_pages_delta",
            dygraphOutput("wikidata_daily_pages_delta_plot"),
            tags$br(),
            htmlOutput("legend_daily_pages"),
            checkboxInput("checkbox_total_pages", label = "Show total Pages", value = FALSE),
            checkboxInput("checkbox_total_gooditems", label = "Show total Content Pages", value = FALSE),
            tags$br(),
            fluidRow(
              uiOutput("metric_meta_recent_pages_seeAlso")
            ),
            tags$a(href="./?t=wikidata_daily_pages_delta", "Link here: ", icon("external-link"))),
    tabItem(tabName = "wikidata_daily_users_delta",
            dygraphOutput("wikidata_daily_users_delta_plot"),
            tags$br(),
            htmlOutput("legend_daily_users"),
            checkboxInput("checkbox_total_users", label = "Show total Users", value = FALSE),
            tags$br(),
            fluidRow(
              uiOutput("metric_meta_recent_users_seeAlso")
            ),
            tags$a(href="./?t=wikidata_daily_users_delta", "Link here: ", icon("external-link"))),
    tabItem(tabName = "wikidata_daily_social",
            dygraphOutput("wikidata_daily_social_plot"),
            tags$br(),
            htmlOutput("legend_daily_social")),
    tabItem(tabName = "wikidata_daily_getclaims_property_use",
            fluidRow(
              uiOutput("metric_meta_getclaims_title")
            ),
            DT::dataTableOutput("wikidata_daily_getclaims_property_use_table")),
    tabItem(tabName = "wikidata_rdf_queries",
            fluidRow(
              uiOutput("metric_meta_rdf_queries")
            ),
            DT::dataTableOutput("wikidata_rdf_queries_table")),
    tabItem(tabName = "wikidata_edits",
            fluidRow(
              infoBoxOutput("editdelta")
            ),
            dygraphOutput("wikidata_edits_plot"),
            fluidRow(
              tags$br(),
              uiOutput("metric_meta_edits"),
              uiOutput("metric_meta_edits_datasource"),
              tags$br(),
              uiOutput("metric_meta_edits_notes")
             )),
    tabItem(tabName = "wikidata_active_users",
            dygraphOutput("wikidata_active_users_plot"),
            fluidRow(
              tags$br(),
              uiOutput("metric_meta_active_users"),
              uiOutput("metric_meta_active_users_datasource"),
              tags$br(),
              uiOutput("metric_meta_active_users_notes")
            )),
    tabItem(tabName = "wikidata_social_media",
            dygraphOutput("wikidata_social_media_plot"),
            tags$br(),
            htmlOutput("legend_social_media")),
    tabItem(tabName = "wikidata_mailing_lists",
            dygraphOutput("wikidata_mailing_lists_plot"),
            tags$br(),
            htmlOutput("legend_lists"),
            tags$br(),
            dygraphOutput("wikidata_mailing_lists_messages_plot"),
            tags$br(),
            htmlOutput("legend_lists_messages")),
    tabItem(tabName = "wikidata_pages",
            dygraphOutput("wikidata_pages_plot"),
            htmlOutput("legend_pages_monthly"),
            checkboxInput("checkbox_total_pages_monthly", label = "Show total Pages", value = TRUE),
            checkboxInput("checkbox_total_gooditems_monthly", label = "Show total Content Pages", value = FALSE),
            fluidRow(
              tags$br(),
              uiOutput("metric_meta_pages"),
              uiOutput("metric_meta_pages_datasource"),
              tags$br(),
              uiOutput("metric_meta_pages_notes")
            )),
    tabItem(tabName = "wikidata_items",
            dygraphOutput("wikidata_content_items_plot"),
            fluidRow(
              tags$br(),
              uiOutput("metric_meta_items"),
              uiOutput("metric_meta_items_datasource"),
              tags$br(),
              uiOutput("metric_meta_items_notes")
            )),
    tabItem(tabName = "wikidata_properties",
            dygraphOutput("wikidata_properties_plot"),
            fluidRow(
              tags$br(),
              uiOutput("metric_meta_properties"),
              uiOutput("metric_meta_properties_datasource"),
              tags$br(),
              uiOutput("metric_meta_properties_notes")
            )),
    tabItem(tabName = "wikidata_references_overview",
            dygraphOutput("wikidata_references_overview_plot"),
            htmlOutput("legend"),
              fluidRow(
              tags$br(),
              uiOutput("metric_meta_references_overview"),
              uiOutput("metric_meta_references_overview_datasource"),
              tags$br(),
              uiOutput("metric_meta_references_overview_notes")
            )),
    tabItem(tabName = "wikidata_content_refstmts",
            dygraphOutput("wikidata_content_refstmts_plot"),
            htmlOutput("legend_refstmts"),
            tags$hr(),
            dygraphOutput("wikidata_content_refstmts_wikipedia_plot"),
            htmlOutput("legend_refstmts_wikipedia"),
            tags$hr(),
            dygraphOutput("wikidata_content_refstmts_other_plot"),
            htmlOutput("legend_refstmts_other")),
    tabItem(tabName = "wikidata_content_references",
            dygraphOutput("wikidata_content_references_plot"),
            htmlOutput("legend_references"),
            checkboxInput("checkbox_ref_itemlink", label = "Show itemlink", value = TRUE)),
    tabItem(tabName = "wikidata_content_statement_ranks",
            dygraphOutput("wikidata_content_statement_ranks_plot"),
            htmlOutput("legend_statement_ranks"),
            checkboxInput("checkbox_normal_rank", label = "Show normal", value = FALSE)),
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
            fluidRow(
              uiOutput("metric_meta_community_health_objects")
            ),
            dygraphOutput("wikidata_kpi_active_editors_plot"),
            tags$br(),
            fluidRow(
              uiOutput("metric_meta_community_health"),
              uiOutput("metric_meta_community_health_seeAlso")
            )),
    tabItem(tabName = "wikidata_quality",
            fluidRow(
              uiOutput("metric_meta_quality_objects2")
            ),
            fluidRow(
              uiOutput("wikipedia_references_info"),
              infoBoxOutput("wikipedia_references_info_scorebox")
            ),
            tags$br(),
            fluidRow(
              uiOutput("metric_meta_quality2"),
              uiOutput("metric_meta_quality2_seeAlso")
            ),
            tags$hr(),
            fluidRow(
              uiOutput("metric_meta_quality_objects1")
            ),
            tags$br(),
            fluidRow(
              uiOutput("metric_meta_quality1")
            )),
    tabItem(tabName = "wikidata_partnerships",
            fluidRow(
              uiOutput("metric_meta_partnerships_objects")
            ),
            tags$br(),
            fluidRow(
              uiOutput("metric_meta_partnerships")
            )),
    tabItem(tabName = "wikidata_external_use",
            fluidRow(
              uiOutput("metric_meta_external_use_objects")
            ),
            tags$br(),
            fluidRow(
              uiOutput("metric_meta_external_use")
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
