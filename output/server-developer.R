#Developer API Metrics

# http://wikiba.se/metrics#GetClaimsPropertyUse
output$metric_meta_getclaims_title <- renderUI({
  first_sample <- head(wikidata_daily_getclaims_property_use$date, 1)
  last_sample <- tail(wikidata_daily_getclaims_property_use$date, 1)
  metric_desc <- "Aggregate getClaim Property Use count"
  metric_range <- paste0("From ", first_sample, " To ", last_sample)
  box(title = "Definition", width = 6, status = "info", metric_desc, HTML("<br/>"), metric_range)
})
aggr_props <- aggregate(wikidata_daily_getclaims_property_use$count, by=list(wikidata_daily_getclaims_property_use$property), FUN = sum)
aggr_props_ordered <- aggr_props[order(aggr_props$x, decreasing = TRUE),]
output$wikidata_daily_getclaims_property_use_table <-DT::renderDataTable(datatable(aggr_props_ordered, class = "display compact", colnames = c("Property", "Value"), rownames = FALSE, options = list(pageLength = 50, autoWidth = TRUE, columnDefs = list(list(className = 'dt-left', targets = c(0,1))))))