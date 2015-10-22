#Graphite Metrics

# http://wikiba.se/metrics#addUsagesForPage
output$wikidata_addUsagesForPage_plot <- renderDygraph({
  drop <- c("desc")
  wikidata_addUsagesForPage <- wikidata_addUsagesForPage[,!(names(wikidata_addUsagesForPage) %in% drop)]
  wikidata_addUsagesForPage <- type_convert(wikidata_addUsagesForPage, list(col_datetime(), col_double()))
  df_addUsagesForPage_ordered <- wikidata_addUsagesForPage[order(wikidata_addUsagesForPage$date, decreasing =TRUE),]
  dt_addUsagesForPage <- data.table(df_addUsagesForPage_ordered)
  dt_addUsagesForPage <- dt_addUsagesForPage[, list(date, value)]
  return(dygraph(dt_addUsagesForPage,
                 main = "Wikidata Usages for Page",
                 ylab = "") %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     fillGraph = TRUE,
                     strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
           dyCSS(css = custom_css))
})