#Content Metrics

# http://wikiba.se/metrics#Pages
output$wikidata_pages_plot <- renderDygraph({
  df_pages_ordered <- wikidata_pages[order(wikidata_pages$date, decreasing =TRUE),]
  df_pages <- df_pages_ordered[1:11,]
  df_gooditems_ordered <- wikidata_gooditems[order(wikidata_gooditems$date, decreasing =TRUE),]
  df_gooditems <- df_gooditems_ordered[1:11,]
  df_content <- data.frame(df_pages, df_gooditems)
  dt_content <- data.table(df_content)
  dt_content <- dt_content[, list(date, count, count.1)]
  return(dygraph(dt_content,
                 main = "Wikidata Pages",
                 ylab = "") %>%
           dyLegend(width = 400, show = "always", labelsDiv = "legend_pages_monthly", labelsSeparateLines = TRUE) %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     fillGraph = TRUE,
                     strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
           dyCSS(css = custom_css) %>%
           dyVisibility(visibility=c(input$checkbox_total_pages_monthly, input$checkbox_total_gooditems_monthly)))
})
output$metric_meta_pages <- renderUI({
  box(title = "Individual", width = 6, status = "primary", tags$a(href = content_obj[13], content_obj[13]))
})
output$metric_meta_pages_datasource <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",content_obj[13],">"), "<http://wikiba.se/metrics#dataSourceURI>")
  box(title = "dataSourceURI", width = 6, status = "info", tags$a(href=metric_desc[1], metric_desc[1]))
})
output$metric_meta_pages_notes <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",content_obj[13],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  box(title = "Comment", width = 6, status = "info", metric_desc[1])
})
# http://wikiba.se/metrics#Items
output$wikidata_content_items_plot <- renderDygraph({
  wikidata_content_items<- xts(wikidata_content_items[, -1], wikidata_content_items[, 1])
  return(dygraph(wikidata_content_items,
                 main = "Wikidata Items",
                 ylab = "Items") %>%
           dyLegend(width = 400, show = "always") %>%
           dySeries("V1", label = "Items") %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     strokeWidth = 3,
                     colors = brewer.pal(max(3, ncol(data)), "Set1")) %>%
           dyCSS(css = custom_css))
})
output$metric_meta_items <- renderUI({
  box(title = "Individual", width = 6, status = "primary", tags$a(href = content_obj[5], content_obj[5]))
})
output$metric_meta_items_datasource <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",content_obj[5],">"), "<http://wikiba.se/metrics#dataSourceURI>")
  box(title = "dataSourceURI", width = 6, status = "info", tags$a(href=paste0(source_data_uri, metric_desc[1]), metric_desc[1]))
})
output$metric_meta_items_notes <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",content_obj[5],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  box(title = "Comment", width = 6, status = "info", metric_desc[1])
})
# http://wikiba.se/metrics#Properties
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
           dyCSS(css = custom_css))
})
output$metric_meta_properties <- renderUI({
  box(title = "Individual", width = 6, status = "primary", tags$a(href = content_obj[9], content_obj[9]))
})
output$metric_meta_properties_datasource <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",content_obj[9],">"), "<http://wikiba.se/metrics#dataSourceURI>")
  box(title = "dataSourceURI", width = 6, status = "info", tags$a(href=paste0(source_data_uri, metric_desc[1]), metric_desc[1]))
})
output$metric_meta_properties_notes <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",content_obj[9],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  box(title = "Comment", width = 6, status = "info", metric_desc[1])
})
# http://wikiba.se/metrics#References_Overview
output$wikidata_references_overview_plot <- renderDygraph({
  wikidata_references_overview<- xts(wikidata_references_overview[, -1], wikidata_references_overview[, 1])
  return(dygraph(wikidata_references_overview,
                 main = "Wikidata References Overview",
                 ylab = "") %>%
           dyLegend(width = 400, show = "always", labelsDiv = "legend", labelsSeparateLines = TRUE) %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
           dyCSS(css = custom_css))
})
output$metric_meta_references_overview <- renderUI({
  box(title = "Individual", width = 6, status = "primary", tags$a(href = content_obj[1], content_obj[1]))
})
output$metric_meta_references_overview_datasource <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",content_obj[1],">"), "<http://wikiba.se/metrics#dataSourceURI>")
  box(title = "dataSourceURI", width = 6, status = "info", tags$a(href=paste0(source_data_uri, metric_desc[1]), metric_desc[1]))
})
output$metric_meta_references_overview_notes <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",content_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  box(title = "Comment", width = 6, status = "info", metric_desc[1])
})
# http://wikiba.se/metrics#Referenced_Statements_by_Type
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
           dyCSS(css = custom_css))
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
           dyCSS(css = custom_css))
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
           dyCSS(css = custom_css))
})
# http://wikiba.se/metrics#References_by_Type
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
           dyCSS(css = custom_css) %>%
           dyVisibility(visibility=c(TRUE, TRUE, TRUE, TRUE, input$checkbox_ref_itemlink)))
})
# http://wikiba.se/metrics#Statement_Ranks
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
           dyCSS(css = custom_css)  %>%
           dyVisibility(visibility=c(TRUE, input$checkbox_normal_rank, TRUE)))
})
# http://wikiba.se/metrics#Statements_per_Item
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
           dyCSS(css = custom_css))
})
# http://wikiba.se/metrics#Labels_per_Item
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
           dyCSS(css = custom_css))
})
# http://wikiba.se/metrics#Descriptions_per_Item
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
           dyCSS(css = custom_css))
})
# http://wikiba.se/metrics#Wikimedia_links_per_item
output$wikidata_content_wikilinks_item_plot <- renderDygraph({
  wikidata_content_wikilinks_item<- xts(wikidata_content_wikilinks_item[, -1], wikidata_content_wikilinks_item[, 1])
  return(dygraph(wikidata_content_wikilinks_item,
                 main = "Wiki(m|p)edia links per item",
                 ylab = "Links") %>%
           dyLegend(width = 400, show = "always", labelsDiv = "legend_wikilinks_item", labelsSeparateLines = TRUE) %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     stackedGraph = TRUE,
                     plotter = barChartPlotter) %>%
           dyCSS(css = custom_css))
})