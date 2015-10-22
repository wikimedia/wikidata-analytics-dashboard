get_local_datasets <- function(){
  wikidata_social_media <<- get_local_set("wikidata_eng_social_media.tsv")
  wikidata_mailing_lists <<-get_local_set("wikidata_eng_mailing_lists.tsv")
  wikidata_mailing_lists_messages <<-get_local_set("wikidata_eng_mailing_lists_messages.tsv")
  wikidata_references_overview <<- get_local_set("wikidata_content_references_overview.tsv")
  wikidata_content_items <<- get_local_set("wikidata_content_items.tsv")
  wikidata_properties <<- get_local_set("wikidata_content_properties.tsv")
  wikidata_content_refstmts <<-get_local_set("wikidata_content_refstmts.tsv")
  wikidata_content_refstmts_wikipedia <<- get_local_set("wikidata_content_refstmts_wikipedia.tsv")
  wikidata_content_refstmts_other <<- get_local_set("wikidata_content_refstmts_other.tsv")
  wikidata_content_references <<-get_local_set("wikidata_content_references.tsv")
  wikidata_content_statement_ranks <<- get_local_set("wikidata_content_statement_ranks.tsv")
  wikidata_content_statement_item <<- get_local_set("wikidata_content_statement_item.tsv")
  wikidata_content_labels_item <<- get_local_set("wikidata_content_labels_item.tsv")
  wikidata_content_descriptions_item <<- get_local_set("wikidata_content_descriptions_item.tsv")
  wikidata_content_wikilinks_item <<- get_local_set("wikidata_content_wikimedia_links_item.tsv")
  wikidata_kpi_active_editors <<- get_local_set("wikidata_kpi_active_editors.tsv")
  return(invisible())
}

get_local_sparql_results <- function(){
  sparql1 <<- get_local_set("spql1.tsv", sparql_data_uri)
  sparql2 <<- get_local_set("spql2.tsv", sparql_data_uri)
  sparql3 <<- get_local_set("spql3.tsv", sparql_data_uri)
  sparql13 <<- get_local_set("spql13.tsv", sparql_data_uri)
  return(invisible())
}

get_graphite_datasets <- function(){
  out <- tryCatch({
    con <- curl(agg_data_uri)
    readLines(con)
  },
  warning = function(cond){
    message(paste("URL caused a warning:", agg_data_uri))
    message("Warning message:")
    message(cond)
    return(NULL)
  },
  error = function(cond){
    message(paste("URL does not exist:", agg_data_uri))
    message("Error message:")
    message(cond)
    return(NA)
  },
  finally = {
    wikidata_addUsagesForPage <<- get_csv_from_api("jobrunner.pop.wikibase-addUsagesForPage.ok.mw1004.count&format=csv",graphite_api_uri)
  })
  return(out)
}

get_remote_datasets <- function(){
  out <- tryCatch({
        con <- curl(agg_data_uri)
        readLines(con)
      },
      warning = function(cond){
        message(paste("URL caused a warning:", agg_data_uri))
        message("Warning message:")
        message(cond)
        return(NULL)
      },
      error = function(cond){
        message(paste("URL does not exist:", agg_data_uri))
        message("Error message:")
        message(cond)
        return(NA)
      },
      finally = {
      wikidata_edits <<- download_set("site_stats_total_edits.tsv", agg_data_uri)
      wikidata_active_users <<- download_set("site_stats_active_users.tsv", agg_data_uri)
      wikidata_pages <<- download_set("site_stats_total_pages.tsv", agg_data_uri)
      wikidata_gooditems <<- download_set("site_stats_good_articles.tsv", agg_data_uri)
      wikidata_daily_getclaims_property_use <<- download_set("getclaims_property_use.tsv", agg_data_uri)
      wikidata_facebook <<- download_set("social_facebook.tsv", agg_data_uri)
      wikidata_googleplus <<- download_set("social_googleplus.tsv", agg_data_uri)
      wikidata_twitter <<- download_set("social_twitter.tsv", agg_data_uri)
      wikidata_identica <<- download_set("social_identica.tsv", agg_data_uri)
      wikidata_irc <<- download_set("social_irc.tsv", agg_data_uri)
      })
  return(out)
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
  daily_obj <<- get_rdf_individuals("<http://wikiba.se/metrics#Daily>")
  return(invisible())
}
