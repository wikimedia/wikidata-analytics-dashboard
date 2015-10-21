#KPI Metrics

# http://wikiba.se/metrics#Community_Health
output$metric_meta_community_health_objects <- renderUI({
  standard_individual_box(community_health_obj[1])
})
output$wikidata_kpi_active_editors_plot <- renderDygraph({
  wikidata_kpi_active_editors<- xts(wikidata_kpi_active_editors[, -1], wikidata_kpi_active_editors[, 1])
  return(dygraph(wikidata_kpi_active_editors,
                 main = "Wikidata Active Editors",
                 ylab = "Active Editors") %>%
           dyLegend(width = 400, show = "always") %>%
           dySeries("V1", label = "Active Editors") %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     strokeWidth = 3,
                     colors = brewer.pal(max(3, ncol(data)), "Set1")) %>%
           dyCSS(css = custom_css))
})
output$metric_meta_community_health <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",community_health_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  standard_comment_box(metric_desc[1])
})
output$metric_meta_community_health_seeAlso <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",community_health_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#seeAlso>")
  standard_seeAlso_box(metric_desc[1], metric_desc[1])
})
# http://wikiba.se/metrics#Quality
output$metric_meta_quality_objects1 <- renderUI({
  standard_individual_box(quality_obj[1])
})
output$metric_meta_quality1 <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",quality_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  standard_comment_box(metric_desc[1])
})
output$metric_meta_quality_objects2 <- renderUI({
  standard_individual_box(quality_obj[2])
})
output$wikipedia_references_info <- renderUI({
  data_period <- tail(wikidata_references_overview[,1], 2)
  period_previous <- format(data_period[1])
  period_current <- format(data_period[2])
  total_statements <- tail(wikidata_references_overview[,3], 2)
  referenced_statements_other <-tail(wikidata_references_overview[,6], 2)
  metric_value_previous_raw <- referenced_statements_other[1]/total_statements[1]
  metric_value_previous <- percent(metric_value_previous_raw)
  metric_value_latest_raw <- referenced_statements_other[2]/total_statements[2]
  metric_value_latest <- percent(metric_value_latest_raw)
  referenced_statements_latest <- prettyNum(referenced_statements_other[2], big.mark=",")
  referenced_statements_previous <- prettyNum(referenced_statements_other[1], big.mark=",")
  box_title <- paste0("Metric Value")
  box_value <- paste0(period_current, " : ", metric_value_latest, " - ", referenced_statements_latest)
  box_value2 <- paste0(period_previous, " : ", metric_value_previous, " - ", referenced_statements_previous)
  references_info <<- c(metric_value_previous_raw,metric_value_latest_raw)
  references_delta_score <<- diff(references_info)
  box(title = box_title, status = "warning", box_value, tags$br(), box_value2, tags$br())
})
output$wikipedia_references_info_scorebox <- renderInfoBox({
  box_title <- paste0("Delta Score")
  if(diff(references_info) > 0) {
    infoBox(box_title, percent(references_delta_score), icon = icon("arrow-up"),
            color = "green"
    )
  }
})
output$metric_meta_quality2_seeAlso <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",quality_obj[2],">"), "<http://www.w3.org/2000/01/rdf-schema#seeAlso>")
  standard_seeAlso_box(metric_desc[1], metric_desc[1])
})
output$metric_meta_quality2 <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",quality_obj[2],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  standard_comment_box(metric_desc[1])
})
# http://wikiba.se/metrics#Partnerships
output$metric_meta_partnerships_objects <- renderUI({
  standard_individual_box(partnerships_obj[1])
})
output$metric_meta_partnerships <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",partnerships_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  standard_comment_box(metric_desc[1])
})
# http://wikiba.se/metrics#External_Use
output$metric_meta_external_use_objects <- renderUI({
  standard_individual_box(external_use_obj[1])
})
output$metric_meta_external_use <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",external_use_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  standard_comment_box(metric_desc[1])
})

# http://wikiba.se/metrics#Internal_Use
output$metric_meta_internal_use_objects1 <- renderUI({
  standard_individual_box(internal_use_obj[1])
})
output$metric_meta_internal_use1 <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",internal_use_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  standard_comment_box(metric_desc[1])
})
output$metric_meta_internal_use_objects2 <- renderUI({
  standard_individual_box(internal_use_obj[2])
})
output$metric_meta_internal_use2 <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",internal_use_obj[2],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  standard_comment_box(metric_desc[1])
})