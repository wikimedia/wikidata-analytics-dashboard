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

  data <- download_set("wikidata_content_refstmts_other.tsv")
  wikidata_content_refstmts_other <<- data

  data <- download_set("wikidata_content_references.tsv")
  wikidata_content_references <<- data

  data <- download_set("wikidata_content_statement_ranks.tsv")
  wikidata_content_statement_ranks <<- data

  data <- download_set("wikidata_content_statement_item.tsv")
  wikidata_content_statement_item <<- data

  data <- download_set("wikidata_content_labels_item.tsv")
  wikidata_content_labels_item <<- data

  data <- download_set("wikidata_content_descriptions_item.tsv")
  wikidata_content_descriptions_item <<- data

  data <- download_set("wikidata_content_wikilinks_item.tsv")
  wikidata_content_wikilinks_item <<- data

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
                 "", "Edits", "Wikidata Edits",
                 smoothing = ifelse(smooth_level == "global", input$smoothing_global, smooth_level))
  })
  output$wikidata_pages_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_pages
    make_dygraph(wikidata_pages,
                 "", "Pages", "Wikidata Pages", legend_name = "pages",
                 smoothing = ifelse(smooth_level == "global", input$smoothing_global, smooth_level))
  })
  output$wikidata_properties_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_properties
    wikidata_properties<- xts(wikidata_properties[, -1], wikidata_properties[, 1])
    return(dygraph(wikidata_properties,
                   main = "Wikidata Properties",
                   ylab = "Properties") %>%
             dyLegend(width = 400, show = "always") %>%
             dySeries("V1", label = "properties") %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       connectSeparatedPoints = TRUE,
                       strokeWidth = 3,
                       colors = brewer.pal(max(3, ncol(data)), "Set1")) %>%
             dyCSS(css = "./assets/css/custom.css"))
  })
  output$wikidata_active_users_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_active_users
    make_dygraph(wikidata_active_users,
                 "", "Active Users", "Wikidata Active Users", legend_name = "active users",
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
                   ylab = "Statements") %>%
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
                   ylab = "Statements") %>%
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
                   ylab = "Statements") %>%
             dyLegend(width = 400, show = "always", labelsDiv = "legend_refstmts_wikipedia", labelsSeparateLines = TRUE) %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       stackedGraph = TRUE,
                       plotter = barChartPlotter) %>%
             dyCSS(css = "./assets/css/custom.css"))
  })
  output$wikidata_content_refstmts_other_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_content_refstmts_other
    wikidata_content_refstmts_other<- xts(wikidata_content_refstmts_other[, -1], wikidata_content_refstmts_other[, 1])
    return(dygraph(wikidata_content_refstmts_other,
                   main = "Referenced Statements to Other Sources by Type",
                   ylab = "Statements") %>%
             dyLegend(width = 400, show = "always", labelsDiv = "legend_refstmts_other", labelsSeparateLines = TRUE) %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       stackedGraph = TRUE,
                       plotter = barChartPlotter) %>%
             dyCSS(css = "./assets/css/custom.css"))
  })
  output$wikidata_content_references_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_content_references
    wikidata_content_references<- xts(wikidata_content_references[, -1], wikidata_content_references[, 1])
    return(dygraph(wikidata_content_references,
                   main = "References by Type",
                   ylab = "References") %>%
             dyLegend(width = 400, show = "always", labelsDiv = "legend_references", labelsSeparateLines = TRUE) %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       stackedGraph = TRUE,
                       plotter = barChartPlotter) %>%
             dyCSS(css = "./assets/css/custom.css"))
  })
  output$wikidata_content_statement_ranks_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_content_statement_ranks
    wikidata_content_statement_ranks<- xts(wikidata_content_statement_ranks[, -1], wikidata_content_statement_ranks[, 1])
    return(dygraph(wikidata_content_statement_ranks,
                   main = "Statement Ranks",
                   ylab = "Ranks") %>%
             dyLegend(width = 400, show = "always", labelsDiv = "legend_statement_ranks", labelsSeparateLines = TRUE) %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       stackedGraph = TRUE,
                       plotter = barChartPlotter) %>%
             dyCSS(css = "./assets/css/custom.css"))
  })
  output$wikidata_content_statement_item_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_content_statement_item
    wikidata_content_statement_item<- xts(wikidata_content_statement_item[, -1], wikidata_content_statement_item[, 1])
    return(dygraph(wikidata_content_statement_item,
                   main = "Statements per Item",
                   ylab = "Statements") %>%
             dyLegend(width = 400, show = "always", labelsDiv = "legend_statement_item", labelsSeparateLines = TRUE) %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       stackedGraph = TRUE,
                       plotter = barChartPlotter) %>%
             dyCSS(css = "./assets/css/custom.css"))
  })
  output$wikidata_content_labels_item_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_content_labels_item
    wikidata_content_labels_item<- xts(wikidata_content_labels_item[, -1], wikidata_content_labels_item[, 1])
    return(dygraph(wikidata_content_labels_item,
                   main = "Labels per Item",
                   ylab = "Labels") %>%
             dyLegend(width = 400, show = "always", labelsDiv = "legend_labels_item", labelsSeparateLines = TRUE) %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       stackedGraph = TRUE,
                       plotter = barChartPlotter) %>%
             dyCSS(css = "./assets/css/custom.css"))
  })
  output$wikidata_content_descriptions_item_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_content_descriptions_item
    wikidata_content_descriptions_item<- xts(wikidata_content_descriptions_item[, -1], wikidata_content_descriptions_item[, 1])
    return(dygraph(wikidata_content_descriptions_item,
                   main = "Descriptions per Item",
                   ylab = "Descriptions") %>%
             dyLegend(width = 400, show = "always", labelsDiv = "legend_descriptions_item", labelsSeparateLines = TRUE) %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       stackedGraph = TRUE,
                       plotter = barChartPlotter) %>%
             dyCSS(css = "./assets/css/custom.css"))
  })
  output$wikidata_content_wikilinks_item_plot <- renderDygraph({
  smooth_level <- input$smoothing_wikidata_content_wikilinks_item
  wikidata_content_wikilinks_item<- xts(wikidata_content_wikilinks_item[, -1], wikidata_content_wikilinks_item[, 1])
  return(dygraph(wikidata_content_wikilinks_item,
                 main = "Wikilinks per Item",
                 ylab = "Links") %>%
           dyLegend(width = 400, show = "always", labelsDiv = "legend_wikilinks_item", labelsSeparateLines = TRUE) %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     stackedGraph = TRUE,
                     plotter = barChartPlotter) %>%
           dyCSS(css = "./assets/css/custom.css"))
})
})
