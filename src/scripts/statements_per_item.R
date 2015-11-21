#Bulk Query of WDQS for Statement per Item Counts and write to TSV

src.path <- "/srv/dashboards/shiny-server/wdm/src/"
output.path <- "/srv/dashboards/shiny-server/wdm/data/sparql/"
source(paste0(src.path, "config.R"), chdir=T)
source(paste0(src.path, "utils.R"), chdir=T)

write_statement_item_counts <- function(filename) {
  query <- get_item_list_query()
  prefix <- get_property_label_prefixes()
  doc <- get_sparql_result(wdmrdf_uri, prefix, query)
  ilist <- get_dataframe_from_xml_result(doc, "//sq:uri")
  items <- data.frame(ilist)
  values <- lapply(items$text, function(x) get_statements_per_item(wdqs_uri, x))
  vals <- data.frame(Reduce(rbind, values))
  statement_counts <- data.table(vals)
  items <- data.table(items$text)
  items$id <- seq_len(nrow(items))
  statement_counts$id <- seq_len(nrow(statement_counts))
  setkey(items, id)
  setkey(statement_counts, id)
  dt_join_items <- items[statement_counts]
  dt_join_statements_item <- dt_join_items[,.SD,.SDcols=c(1,3)]
  dt_join_statements_item  <- setnames(dt_join_statements_item , c("Item","Statement Count"))
  write.table(dt_join_statements_item, paste0(output.path,filename), sep = "\t", row.names = FALSE)
}

write_statement_item_counts("statements_per_item.tsv")