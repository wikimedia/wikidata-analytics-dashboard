get_datasets <- function(){
  wikidata_edits <<- download_set("wikidata_eng_edits.tsv")
  wikidata_active_users <<- download_set("wikidata_eng_active_users.tsv")
  wikidata_social_media <<- download_set("wikidata_eng_social_media.tsv")
  wikidata_mailing_lists <<-download_set("wikidata_eng_mailing_lists.tsv")
  wikidata_mailing_lists_messages <<-download_set("wikidata_eng_mailing_lists_messages.tsv")
  wikidata_references_overview <<- download_set("wikidata_content_references_overview.tsv")
  wikidata_pages <<- download_set("wikidata_content_pages.tsv")
  wikidata_content_items <<- download_set("wikidata_content_items.tsv")
  wikidata_properties <<- download_set("wikidata_content_properties.tsv")
  wikidata_content_refstmts <<-download_set("wikidata_content_refstmts.tsv")
  wikidata_content_refstmts_wikipedia <<- download_set("wikidata_content_refstmts_wikipedia.tsv")
  wikidata_content_refstmts_other <<- download_set("wikidata_content_refstmts_other.tsv")
  wikidata_content_references <<-download_set("wikidata_content_references.tsv")
  wikidata_content_statement_ranks <<- download_set("wikidata_content_statement_ranks.tsv")
  wikidata_content_statement_item <<- download_set("wikidata_content_statement_item.tsv")
  wikidata_content_labels_item <<- download_set("wikidata_content_labels_item.tsv")
  wikidata_content_descriptions_item <<- download_set("wikidata_content_descriptions_item.tsv")
  wikidata_content_wikilinks_item <<- download_set("wikidata_content_wikimedia_links_item.tsv")
  wikidata_kpi_active_editors <<- download_set("wikidata_kpi_active_editors.tsv")
  wikidata_daily_social <<- download_set("social.tsv", agg_data_uri)
  wikidata_daily_site <<- download_set("site_stats.tsv", agg_data_uri)
  wikidata_daily_getclaims_property_use <<- download_set("getclaims_property_use.tsv", agg_data_uri)
  return(invisible())
}

load_rdf_model <-function(){
  metrics_model <<- load.rdf(metrics_rdf)
}

get_rdf_objects <- function(){
  engagement_obj <<- get_rdf_individuals("<http://wikiba.se/metrics#Engagement>")
  content_obj <<- get_rdf_individuals("<http://wikiba.se/metrics#Content>")
  community_health_obj <<- get_rdf_individuals("<http://wikiba.se/metrics#Community_Health>")
  quality_obj <<- get_rdf_individuals("<http://wikiba.se/metrics#Quality>")
  partnerships_obj <<- get_rdf_individuals("<http://wikiba.se/metrics#Partnerships>")
  external_use_obj <<- get_rdf_individuals("<http://wikiba.se/metrics#External_Use>")
  internal_use_obj <<- get_rdf_individuals("<http://wikiba.se/metrics#Internal_Use>")
  return(invisible())
}
