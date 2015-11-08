#Bulk Query of WDQS for Property Use Counts and write to TSV
source("/srv/dashboards/shiny-server/wdm/src/config.R")
source("/srv/dashboards/shiny-server/wdm/src/utils.R")

write_prop_usage_counts <- function() {
  query <- get_property_list_query()
  prefix <- get_property_label_prefixes()
  plist <- get_sparql_result_from_uri(wdmrdf_uri, prefix, query)
  props <- lapply(plist, function(x) gsub("http://www.wikidata.org/entity/", "", x))
  values <- lapply(props$text, function(x) get_estimated_card_from_prop_predicate(estcard.uri, x))
  vals <- do.call(c, unlist(values, recursive=FALSE))
  prop_counts <- data.table(vals)
  props <- data.table(props$text)
  props$id <- seq_len(nrow(props))
  prop_counts$id <- seq_len(nrow(prop_counts))
  setkey(props, id)
  setkey(prop_counts, id)
  dt_join_prop_usage <- props[prop_counts]
  dt_join_prop_usage <- dt_join_prop_usage[,.SD,.SDcols=c(1,3)]
  dt_join_prop_usage <- setnames(dt_join_prop_usage, c("Property", "Count"))
  write.table(dt_join_prop_usage, "/srv/dashboards/shiny-server/wdm/data/sparql/prop_usage.tsv", sep = "\t", row.names = FALSE)
}

write_prop_usage_counts()