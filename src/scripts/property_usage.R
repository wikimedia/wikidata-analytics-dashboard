#Bulk Query of WDQS for Property Use Counts and write to TSV

src.path <- "/srv/dashboards/shiny-server/wdm/src/"
output.path <- "/srv/dashboards/shiny-server/wdm/data/sparql/"
source(paste0(src.path, "config.R"), chdir=T)
source(paste0(src.path, "utils.R"), chdir=T)

write_prop_usage_counts <- function(filename, predicate) {
  query <- get_property_list_query()
  prefix <- get_property_label_prefixes()
  doc <- get_sparql_result(wdmrdf_uri, prefix, query)
  plist <- get_dataframe_from_xml_result(doc, "//sq:uri")
  props <- lapply(plist, function(x) gsub("http://www.wikidata.org/entity/", "", x))
  props <- data.frame(props)
  values <- lapply(props$text, function(x) get_estimated_card_from_prop_predicate(estcard.uri, predicate, x))
  vals <- do.call(c, unlist(values, recursive=FALSE))
  labels <- get_dataframe_from_xml_result(doc, "//sq:literal")
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
  write.table(dt_join_prop_usage, paste0(output.path,filename), sep = "\t", row.names = FALSE)
}

wd_prop_predicates <- c("prop/statement/","prop/statement/value/",
                        "prop/reference/","prop/reference/value/","prop/qualifier/",
                        "prop/qualifier/value/","prop/direct/")
wd_prop_count_files <- c("property_statement_usage.tsv", "property_statement_value_usage.tsv",
                         "property_reference_usage.tsv", "property_reference_value_usage.tsv",
                         "property_qualifier_usage.tsv", "property_qualifier_value_usage.tsv",
                         "property_direct_usage.tsv")
write_prop_usage_counts("statement_value_property_usage.tsv", "prop/statement/value/")