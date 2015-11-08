#RDF Property Use Counts

# http://wikiba.se/metrics#Property_Use
output$metric_meta_rdf_queries <- renderUI({
  metric_desc <- "Property Use Counts"
  box(title = "Definition", width = 6, status = "info", metric_desc)
})
output$wikidata_property_usage_count_table <- DT::renderDataTable({
  datatable(property_usage_counts,   class = "display compact", colnames = c("Property", "Count"),
            options = list(
              order = list(2, 'desc'),
              pageLength = 100,
              columnDefs = list(
                list(className = 'dt-left', targets = c(1,2)),
                list(visible = FALSE, targets = c(0)),
                list(targets = c(1), render = JS(
                  "function(data, type, row, meta) {",
                  "return '<a href=\"https://www.wikidata.org/wiki/Property:'+data+'\" target=\"_blank\">'+data+'</a>'",
                  "}")
                )
              )
            ),
  caption = "Property Usage Counts") %>%
  formatCurrency(c("Count"), currency = "", interval = 3, mark = ",")
})


