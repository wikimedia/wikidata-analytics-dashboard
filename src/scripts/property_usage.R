#Bulk Query of WDQS for Property Use Counts and write to TSV

src.path <- "/srv/dashboards/shiny-server/wdm/src/"
source(paste0(src.path, "config.R"), chdir=T)
source(paste0(src.path, "utils.R"), chdir=T)

write_prop_usage_counts <- function() {
  query <- get_property_list_query()
  prefix <- get_property_label_prefixes()
  doc <- get_sparql_result(wdmrdf_uri, prefix, query)
  plist <- get_dataframe_from_xml_result(doc, "//sq:uri")
  props <- lapply(plist, function(x) gsub("http://www.wikidata.org/entity/", "", x))
  labels <- get_dataframe_from_xml_result(doc, "//sq:literal")
  values <- lapply(props$text, function(x) get_estimated_card_from_prop_predicate(estcard.uri, x))
  vals <- do.call(c, unlist(values, recursive=FALSE))
  labels <- data.table(labels$text)
  labels$id <- seq_len(nrow(labels))
  prop_counts <- data.table(vals)
  props <- data.table(props$text)
  props$id <- seq_len(nrow(props))
  prop_counts$id <- seq_len(nrow(prop_counts))
  setkey(props, id)
  setkey(prop_counts, id)
  setkey(labels, id)
  dt_join_props <- props[labels]
  dt_join_prop_usage <- dt_join_props[prop_counts]
  dt_join_prop_usage <- dt_join_prop_usage[,.SD,.SDcols=c(1,3,4)]
  dt_join_prop_usage <- setnames(dt_join_prop_usage, c("Property","Label","Count"))
  write.table(dt_join_prop_usage, "/srv/dashboards/shiny-server/wdm/data/sparql/prop_usage.tsv", sep = "\t", row.names = FALSE)
}

write_prop_usage_counts()