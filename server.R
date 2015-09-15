## Version 0.2.0
source("utils.R")

existing_date <- (Sys.Date()-1)

## Read in data and generate means for the value boxes, along with a time-series appropriate form for
## dygraphs.
read_desktop <- function(){
  data <- download_set("wikidata-edits.tsv")
  wikidata_edits <<- data

  data <- download_set("wikidata-pages.tsv")
  wikidata_pages <<- data

  data <- download_set("wikidata-properties.tsv")
  wikidata_properties <<- data

  data <- download_set("wikidata-active-users.tsv")
  wikidata_active_users <<- data

  data <- download_set("wikidata-social-media.tsv")
  wikidata_social_media <<- data

  data <- download_set("wikidata-content-overview.tsv")
  wikidata_content_overview <<- data

  data <- download_set("wikidata-content-refstmts.tsv")
  wikidata_content_refstmts <<- data

  data <- download_set("wikidata-content-refstmts-wikipedia.tsv")
  wikidata_content_refstmts_wikipedia <<- data

  return(invisible())
}

shinyServer(function(input, output) {

  if(Sys.Date() != existing_date){
    read_desktop()
    existing_date <<- Sys.Date()
  }

  output$wikidata_edits_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_edits
    make_dygraph(wikidata_edits,
                 "Date", "Edits", "Wikidata Edits, by month",
                 smoothing = ifelse(smooth_level == "global", input$smoothing_global, smooth_level))
  })
  output$wikidata_pages_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_pages
    make_dygraph(wikidata_pages,
                 "Date", "Pages", "Wikidata Pages, by month", legend_name = "pages",
                 smoothing = ifelse(smooth_level == "global", input$smoothing_global, smooth_level))
  })
  output$wikidata_properties_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_properties
    make_dygraph(wikidata_properties,
                 "Date", "Properties", "Wikidata Properties, by month", legend_name = "properties",
                 smoothing = ifelse(smooth_level == "global", input$smoothing_global, smooth_level))
  })
  output$wikidata_active_users_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_active_users
    make_dygraph(wikidata_active_users,
                 "Date", "Active Users", "Wikidata Active Users, by month", legend_name = "active users",
                 smoothing = ifelse(smooth_level == "global", input$smoothing_global, smooth_level))
  })
  output$wikidata_social_media_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_social_media
    wikidata_social_media <- xts(wikidata_social_media[, -1], wikidata_social_media[, 1])
    return(dygraph(wikidata_social_media))
  })
  output$wikidata_content_overview_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_content_overview
    wikidata_content_overview<- xts(wikidata_content_overview[, -1], wikidata_content_overview[, 1])
    return(dygraph(wikidata_content_overview,
                   main = "Wikidata Content Overview",
                   xlab = "Date", ylab = "Statements") %>%
             dyLegend(width = 400, show = "always", labelsDiv = "legend", labelsSeparateLines = TRUE) %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
             dyCSS(css = "./assets/css/custom.css"))
  })
  output$wikidata_content_refstmts_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_content_refstmts
    wikidata_content_refstmts<- xts(wikidata_content_refstmts[, -1], wikidata_content_refstmts[, 1])
    return(dygraph(wikidata_content_refstmts,
                   main = "Referenced Statements by Type",
                   xlab = "Date", ylab = "Statements") %>%
             dyLegend(width = 400, show = "always", labelsDiv = "legend_refstmts", labelsSeparateLines = TRUE) %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       stackedGraph = TRUE,
                       plotter = barChartPlotter) %>%
             dyCSS(css = "./assets/css/custom.css"))
  })
  output$wikidata_content_refstmts_wikipedia_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_content_refstmts_wikipedia
    wikidata_content_refstmts_wikipedia<- xts(wikidata_content_refstmts_wikipedia[, -1], wikidata_content_refstmts_wikipedia[, 1])
    return(dygraph(wikidata_content_refstmts_wikipedia,
                   main = "Referenced Statements to Wikipedia by Type",
                   xlab = "Date", ylab = "Statements") %>%
             dyLegend(width = 400, show = "always", labelsDiv = "legend_refstmts_wikipedia", labelsSeparateLines = TRUE) %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       stackedGraph = TRUE,
                       plotter = barChartPlotter) %>%
             dyCSS(css = "./assets/css/custom.css"))
  })
})
