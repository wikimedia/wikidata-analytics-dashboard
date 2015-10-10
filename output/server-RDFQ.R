#RDF Metrics

# http://wikiba.se/metrics#RDF_Queries
output$metric_meta_rdf_queries <- renderUI({
  metric_desc <- "RDF Queries"
  box(title = "Definition", width = 6, status = "info", metric_desc)
})
qlist <- read_file("./assets/rdfq.xml")
rdfq <- xmlParse(qlist)
queries <- xmlToDataFrame(nodes = getNodeSet(rdfq, "//rdf-query"))
output$wikidata_rdf_queries_table <- DT::renderDataTable(datatable(queries))