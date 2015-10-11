#RDF Metrics

# http://wikiba.se/metrics#RDF_Queries
output$metric_meta_rdf_queries <- renderUI({
  metric_desc <- "RDF Queries"
  box(title = "Definition", width = 6, status = "info", metric_desc)
})
qlist <- read_file("./assets/rdfq.xml")
rdfq <- xmlParse(qlist)
queries <- xmlToDataFrame(nodes = getNodeSet(rdfq, "//rdfq:select", c(rdfq = "http://wikiba.se/rdfq#")))
comments <- xmlToDataFrame(nodes = getNodeSet(rdfq, "//rdfs:comment", c(rdfs = "http://www.w3.org/2000/01/rdf-schema#")))
dt_queries <- data.table(queries)
dt_queries$id <- seq_len(nrow(queries))
dt_comments <- data.table(comments)
dt_comments$id <- seq_len(nrow(dt_comments))
setkey(dt_queries, id)
setkey(dt_comments, id)
dt_join_rdfq <- merge(dt_queries, dt_comments, all=TRUE)
dt_join_rdfq <- dt_join_rdfq[,.SD,.SDcols=c(2:3)]
output$wikidata_rdf_queries_table <- DT::renderDataTable(datatable(dt_join_rdfq,  options = list(pageLength = 50)))