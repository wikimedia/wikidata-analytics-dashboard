#Developer API Metrics

# http://wikiba.se/metrics#GetClaimsPropertyUse
output$metric_meta_getclaims_title <- renderUI({
  first_sample <- head(wikidata_daily_getclaims_property_use$date, 1)
  last_sample <<- tail(wikidata_daily_getclaims_property_use$date, 1)
  metric_desc <- "Aggregate wbgetclaims Property Use count"
  metric_range <- paste0("From ", first_sample, " To ", last_sample)
  box(title = "Definition", width = 6, status = "info", metric_desc, HTML("<br/>"), metric_range)
})
output$wikidata_daily_getclaims_property_use_table <-DT::renderDataTable({
  dt_getclaims_file <- data.table(wikidata_daily_getclaims_property_use)
  setkey(dt_getclaims_file, property)
  dt_getclaims_file <- dt_getclaims_file[which(dt_getclaims_file$date >= last_sample)]
  aggr_props <- aggregate(as.numeric(wikidata_daily_getclaims_property_use$count), by=list(wikidata_daily_getclaims_property_use$property), FUN = sum)
  aggr_props_ordered <- aggr_props[order(aggr_props$x, decreasing = TRUE),]
  dt_agg_props_ordered <- data.table(aggr_props_ordered)
  dt_agg_props_ordered <- setnames(dt_agg_props_ordered, c("property", "count"))
  setkey(dt_agg_props_ordered, property)
  aggr_props_join <- dt_agg_props_ordered[dt_getclaims_file]
  aggr_props_join <- aggr_props_join[,.SD,.SDcols=c(1:2,4)]
  aggr_props_join <- aggr_props_join[order(aggr_props_join$count, decreasing = TRUE)]
  datatable(aggr_props_join, class = "display compact", colnames = c("Property", "Agg. Count", paste0("Last Sample: ", last_sample), "Chart"),
            rownames = FALSE,
            options = list(
              pageLength = 50,
              columnDefs = list(
                list(className = 'dt-left', targets = c(0,1,2)),
                list(data = 0,targets = c(0,3)),
                list(width='10%', targets = c(0)),
                list(width='10%', targets = c(1)),
                list(width='10%', targets = c(2)),
                list(width='10%', targets = c(3)),
                list(targets = c(3), render = JS(
                  "function(data, type, row, meta) {",
                  "return '<a href=\"./?t=wikidata_getclaims_property_graphs&property='+data+'\">Chart</a>'",
                  "}")
                )
              )
            ),
            caption = "Statistics for wbgetclaims Property Use") %>%
            formatCurrency(c("count","i.count"), currency = "", interval = 3, mark = ",")
})


# http://wikiba.se/metrics#ParamPropertyGraph
output$param_property_graph <- renderDygraph({
  #comment_index <- substring(gsub(".tsv", "", params_filename),5)
  #chart_title <- comments[comment_index,]
  dygraph_from_param_property()
})