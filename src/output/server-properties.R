#RDF Property Use Counts

# http://wikiba.se/metrics#Property_Use
output$metric_meta_rdf_queries <- renderUI({
  metric_desc <- "Property Use Counts"
  box(title = "Definition", width = 6, status = "info", metric_desc)
})
output$wikidata_property_usage_count_table <- DT::renderDataTable({
  datatable(property_usage_counts,   class = "display compact", colnames = c("Property", "Label", "Count"),
            options = list(
              order = list(3, 'desc'),
              pageLength = 100,
              columnDefs = list(
                list(className = 'dt-left', targets = c(1,2,3)),
                list(visible = FALSE, targets = c(0)),
                list(width='10%', targets = c(1)),
                list(width='40%', targets = c(2)),
                list(width='40%', targets = c(3)),
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


