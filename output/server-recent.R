#Recent Metrics

# http://wikiba.se/metrics#RecentEdits
wikidata_recent_edits <- wikidata_edits[which(wikidata_edits$date > Sys.Date() - 8),]
recent_date_window <- wikidata_recent_edits$date
current_date = tail(recent_date_window,1)
start_date = head(recent_date_window,1)
df_recent_edits <- wikidata_edits[order(wikidata_edits$date, decreasing =TRUE),]
dt_recent_edits <- data.table(df_recent_edits)
wikidata_daily_edits_delta <- dt_recent_edits[, list(date, count, diff_count=diff(count)*-1)]
output$wikidata_daily_edits_delta_plot <- renderDygraph({
  return(dygraph(head(wikidata_daily_edits_delta, -1),
                 main = "Wikidata Edits/Day Last 7 Days",
                 ylab = "") %>%
           dyLegend(width = 400, show = "always", labelsDiv = "legend_daily_site", labelsSeparateLines = TRUE) %>%
           dyRangeSelector(dateWindow = c(start_date, current_date)) %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
           dyCSS(css = custom_css) %>%
           dyVisibility(visibility=c(input$checkbox_total_edits, TRUE)))
})

output$metric_meta_recent_edits_seeAlso <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",daily_obj[3],">"), "<http://www.w3.org/2000/01/rdf-schema#seeAlso>")
  standard_seeAlso_box(metric_desc[1])
})
# http://wikiba.se/metrics#RecentPages
wikidata_recent_pages <- wikidata_pages[which(wikidata_pages$date > Sys.Date() - 8),]
recent_page_date_window <- wikidata_recent_pages$date
current_page_date = tail(recent_page_date_window,1)
start_page_date = head(recent_page_date_window,1)
df_pages_ordered <- wikidata_pages[order(wikidata_pages$date, decreasing =TRUE),]
df_recent_pages <- df_pages_ordered
df_gooditems_ordered <- wikidata_gooditems[order(wikidata_gooditems$date, decreasing =TRUE),]
df_recent_gooditems <- df_gooditems_ordered
good_items_nrow <- nrow(df_recent_gooditems)
df_recent_content <- data.frame(df_recent_pages[1:good_items_nrow,], df_recent_gooditems)
dt_recent_content <- data.table(df_recent_content)
dt_recent_content <- dt_recent_content[, list(date, count, count.1)]
output$wikidata_daily_pages_delta_plot <- renderDygraph({
  wikidata_daily_pages_delta <- dt_recent_content[, list(date, count, diff_pages=diff(count)*-1, count.1, diff_contentpages=diff(count.1)*-1)]
  return(dygraph(head(wikidata_daily_pages_delta, -1),
                 main = "Wikidata New Pages/Day Last 7 Days",
                 ylab = "") %>%
           dyLegend(width = 400, show = "always", labelsDiv = "legend_daily_pages", labelsSeparateLines = TRUE) %>%
           dyRangeSelector(dateWindow = c(start_page_date, current_page_date)) %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     fillGraph = TRUE,
                     strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
           dyCSS(css = custom_css) %>%
           dyVisibility(visibility=c(input$checkbox_total_pages, TRUE, input$checkbox_total_gooditems, TRUE)))
})
output$metric_meta_recent_pages_seeAlso <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",daily_obj[2],">"), "<http://www.w3.org/2000/01/rdf-schema#seeAlso>")
  standard_seeAlso_box(metric_desc[1])
})
# http://wikiba.se/metrics#RecentUsers
df_recent_users <- wikidata_active_users[order(wikidata_active_users$date, decreasing =TRUE),]
dt_recent_users <- data.table(df_recent_users)
output$wikidata_daily_users_delta_plot <- renderDygraph({
  wikidata_daily_users_delta <- dt_recent_users[, list(date, count, diff_count=diff(count)*-1)]
  return(dygraph(wikidata_daily_users_delta,
                 main = "Wikidata New Active Users/Day Last 7 Days") %>%
           dyLegend(width = 400, show = "always", labelsDiv = "legend_daily_users", labelsSeparateLines = TRUE) %>%
           dyAxis("y", label = "Active Users", valueRange = c(-200, 200)) %>%
           dySeries("count", axis = 'y2') %>%
           dyRangeSelector(dateWindow = c(start_date, current_date)) %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     fillGraph = TRUE,
                     includeZero = TRUE,
                     drawPoints = TRUE,
                     strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
           dyCSS(css = custom_css) %>%
           dyVisibility(visibility=c(TRUE, input$checkbox_total_users)))
})
output$metric_meta_recent_users_seeAlso <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",daily_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#seeAlso>")
  standard_seeAlso_box(metric_desc[1])
})
