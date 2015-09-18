## Version 0.2.0
source("utils.R")

existing_date <- (Sys.Date()-1)

get_datasets <- function(){
  wikidata_edits <<- download_set("wikidata-edits.tsv")
  edits_latest <- cbind("Edits" = safe_tail(wikidata_edits$edits, 2))
  edits_delta <<- diff(edits_latest)
  wikidata_pages <<- download_set("wikidata-pages.tsv")
  wikidata_properties <<- download_set("wikidata-properties.tsv")
  wikidata_active_users <<- download_set("wikidata-active-users.tsv")
  wikidata_social_media <<- download_set("wikidata-social-media.tsv")
  wikidata_mailing_lists <<-download_set("wikidata_mailing_lists.tsv")
  wikidata_content_overview <<- download_set("wikidata-content-overview.tsv")
  wikidata_content_refstmts <<-download_set("wikidata-content-refstmts.tsv")
  wikidata_content_refstmts_wikipedia <<- download_set("wikidata-content-refstmts-wikipedia.tsv")
  wikidata_content_refstmts_other <<- download_set("wikidata_content_refstmts_other.tsv")
  wikidata_content_references <<-download_set("wikidata_content_references.tsv")
  wikidata_content_statement_ranks <<- download_set("wikidata_content_statement_ranks.tsv")
  wikidata_content_statement_item <<- download_set("wikidata_content_statement_item.tsv")
  wikidata_content_labels_item <<- download_set("wikidata_content_labels_item.tsv")
  wikidata_content_descriptions_item <<- download_set("wikidata_content_descriptions_item.tsv")
  wikidata_content_wikilinks_item <<- download_set("wikidata_content_wikilinks_item.tsv")
  return(invisible())
}

shinyServer(function(input, output) {

    if(Sys.Date() != existing_date){
      get_datasets()
      existing_date <<- Sys.Date()
    }

    output$wikidata_edits_plot <- renderDygraph({
      make_dygraph(wikidata_edits,
                   "", "Edits", "Wikidata Edits")
    })
    output$editdelta <- renderInfoBox({
      form_edits <- prettyNum(edits_delta, big.mark=",")
      infoBox(
        "Edit Delta from Last Period", paste0(form_edits), icon = icon("arrow-up"),
        color = "green"
      )
    })
    output$wikidata_pages_plot <- renderDygraph({
      make_dygraph(wikidata_pages,
                   "", "Pages", "Wikidata Pages", legend_name = "pages")
    })
    output$wikidata_properties_plot <- renderDygraph({
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
      make_dygraph(wikidata_active_users,
                   "", "Active Users", "Wikidata Active Users", legend_name = "active users")
    })
    output$wikidata_social_media_plot <- renderDygraph({
      wikidata_social_media <- xts(wikidata_social_media[, -1], wikidata_social_media[, 1])
      return(dygraph(wikidata_social_media,
                     main = "Wikidata Social Media",
                     ylab = "Lists") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_social_media", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_mailing_lists_plot <- renderDygraph({
      wikidata_mailing_lists <- xts(wikidata_mailing_lists[, -1], wikidata_mailing_lists[, 1])
      return(dygraph(wikidata_mailing_lists,
                     main = "Wikidata Mailing Lists",
                     ylab = "Lists") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_lists", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_content_overview_plot <- renderDygraph({
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
