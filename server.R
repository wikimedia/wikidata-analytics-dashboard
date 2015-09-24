## Version 0.2.0
source("utils.R")

existing_date <- (Sys.Date()-1)

get_datasets <- function(){
  wikidata_edits <<- download_set("wikidata-edits.tsv")
  wikidata_active_users <<- download_set("wikidata-active-users.tsv")
  wikidata_social_media <<- download_set("wikidata-social-media.tsv")
  wikidata_mailing_lists <<-download_set("wikidata_mailing_lists.tsv")
  wikidata_content_overview <<- download_set("wikidata-content-overview.tsv")
  wikidata_pages <<- download_set("wikidata-pages.tsv")
  wikidata_content_items <<- download_set("wikidata_content_items.tsv")
  wikidata_properties <<- download_set("wikidata-properties.tsv")
  wikidata_content_refstmts <<-download_set("wikidata-content-refstmts.tsv")
  wikidata_content_refstmts_wikipedia <<- download_set("wikidata-content-refstmts-wikipedia.tsv")
  wikidata_content_refstmts_other <<- download_set("wikidata_content_refstmts_other.tsv")
  wikidata_content_references <<-download_set("wikidata_content_references.tsv")
  wikidata_content_statement_ranks <<- download_set("wikidata_content_statement_ranks.tsv")
  wikidata_content_statement_item <<- download_set("wikidata_content_statement_item.tsv")
  wikidata_content_labels_item <<- download_set("wikidata_content_labels_item.tsv")
  wikidata_content_descriptions_item <<- download_set("wikidata_content_descriptions_item.tsv")
  wikidata_content_wikilinks_item <<- download_set("wikidata_content_wikilinks_item.tsv")
  return(invisible())
}

get_rdf_objects <- function(){
  engagement_obj <<- get_rdf_individuals("<http://wikiba.se/metrics#Engagement>")
  internal_use_objs <<- get_rdf_individuals("<http://wikiba.se/metrics#Internal_Use>")
  return(invisible())
}

shinyServer(function(input, output) {

    if(Sys.Date() != existing_date){
      get_datasets()
      get_rdf_objects()
      existing_date <<- Sys.Date()
    }

    # http://wikiba.se/metrics#Edits
    output$wikidata_edits_plot <- renderDygraph({
      make_dygraph(wikidata_edits,
                   "", "Edits", "Wikidata Edits")
    })
    output$editdelta <- renderInfoBox({
      edits_period <- tail(wikidata_edits$date, 2)
      period_last <- format(edits_period[2])
      period_current <- format(edits_period[1])
      edits_latest <- cbind("Edits" = safe_tail(wikidata_edits$edits, 2))
      edits_delta <- diff(edits_latest)
      edits_last_total <- edits_latest[1]
      edits_delta_percentage <- percent(edits_delta/edits_last_total)
      form_edits <- prettyNum(edits_delta, big.mark=",")
      box_title <- paste0("Edit Delta")
      box_subtitle <- paste0(period_current, " to ", period_last)
      box_value <- paste0(form_edits, " - ", edits_delta_percentage)
      infoBox(box_title, box_value, box_subtitle, icon = icon("arrow-up"),
        color = "green"
      )
    })
    output$metric_meta_edits <- renderUI({
      box(title = "Individual", width = 12, status = "primary", tags$a(href = engagement_obj[1], engagement_obj[1]))
    })
    output$metric_meta_edits_notes <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",engagement_obj[1],">"))
      box(title = "Definition", width = 6, status = "info", metric_desc[1])
    })

    # http://wikiba.se/metrics#Active_Users
    output$wikidata_active_users_plot <- renderDygraph({
      make_dygraph(wikidata_active_users,
                   "", "Active Users", "Wikidata Active Users", legend_name = "active users")
    })
    output$metric_meta_active_users <- renderUI({
      box(title = "Individual", width = 12, status = "primary", tags$a(href = engagement_obj[2], engagement_obj[2]))
    })
    output$metric_meta_active_users_notes <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",engagement_obj[2],">"))
      box(title = "Definition", width = 6, status = "info", metric_desc[1])
    })

    output$wikidata_social_media_plot <- renderDygraph({
      wikidata_social_media <- xts(wikidata_social_media[, -1], wikidata_social_media[, 1])
      return(dygraph(wikidata_social_media,
                     main = "Wikidata Social Media",
                     ylab = "Lists") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_social_media", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_mailing_lists_plot <- renderDygraph({
      wikidata_mailing_lists <- xts(wikidata_mailing_lists[, -1], wikidata_mailing_lists[, 1])
      return(dygraph(wikidata_mailing_lists,
                     main = "Wikidata Mailing Lists",
                     ylab = "Lists") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_lists", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_pages_plot <- renderDygraph({
      make_dygraph(wikidata_pages,
                   "", "Pages", "Wikidata Pages", legend_name = "pages")
    })
    output$wikidata_content_items_plot <- renderDygraph({
      wikidata_content_items<- xts(wikidata_content_items[, -1], wikidata_content_items[, 1])
      return(dygraph(wikidata_content_items,
                     main = "Wikidata Items",
                     ylab = "Items") %>%
               dyLegend(width = 400, show = "always") %>%
               dySeries("V1", label = "Items") %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 3,
                         colors = brewer.pal(max(3, ncol(data)), "Set1")) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_properties_plot <- renderDygraph({
      wikidata_properties<- xts(wikidata_properties[, -1], wikidata_properties[, 1])
      return(dygraph(wikidata_properties,
                     main = "Wikidata Properties",
                     ylab = "Properties") %>%
               dyLegend(width = 400, show = "always") %>%
               dySeries("V1", label = "properties") %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         connectSeparatedPoints = TRUE,
                         strokeWidth = 3,
                         colors = brewer.pal(max(3, ncol(data)), "Set1")) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_content_overview_plot <- renderDygraph({
      wikidata_content_overview<- xts(wikidata_content_overview[, -1], wikidata_content_overview[, 1])
      return(dygraph(wikidata_content_overview,
                     main = "Wikidata References Overview",
                     ylab = "Statements") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_content_refstmts_plot <- renderDygraph({
      wikidata_content_refstmts<- xts(wikidata_content_refstmts[, -1], wikidata_content_refstmts[, 1])
      return(dygraph(wikidata_content_refstmts,
                     main = "Referenced Statements by Type",
                     ylab = "Statements") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_refstmts", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         stackedGraph = TRUE,
                         plotter = barChartPlotter) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_content_refstmts_wikipedia_plot <- renderDygraph({
      wikidata_content_refstmts_wikipedia<- xts(wikidata_content_refstmts_wikipedia[, -1], wikidata_content_refstmts_wikipedia[, 1])
      return(dygraph(wikidata_content_refstmts_wikipedia,
                     main = "Referenced Statements to Wikipedia by Type",
                     ylab = "Statements") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_refstmts_wikipedia", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         stackedGraph = TRUE,
                         plotter = barChartPlotter) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_content_refstmts_other_plot <- renderDygraph({
      wikidata_content_refstmts_other<- xts(wikidata_content_refstmts_other[, -1], wikidata_content_refstmts_other[, 1])
      return(dygraph(wikidata_content_refstmts_other,
                     main = "Referenced Statements to Other Sources by Type",
                     ylab = "Statements") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_refstmts_other", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         stackedGraph = TRUE,
                         plotter = barChartPlotter) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_content_references_plot <- renderDygraph({
      wikidata_content_references<- xts(wikidata_content_references[, -1], wikidata_content_references[, 1])
      return(dygraph(wikidata_content_references,
                     main = "References by Type",
                     ylab = "References") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_references", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         stackedGraph = TRUE,
                         plotter = barChartPlotter) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_content_statement_ranks_plot <- renderDygraph({
      wikidata_content_statement_ranks<- xts(wikidata_content_statement_ranks[, -1], wikidata_content_statement_ranks[, 1])
      return(dygraph(wikidata_content_statement_ranks,
                     main = "Statement Ranks",
                     ylab = "Ranks") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_statement_ranks", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         stackedGraph = TRUE,
                         plotter = barChartPlotter) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_content_statement_item_plot <- renderDygraph({
      wikidata_content_statement_item<- xts(wikidata_content_statement_item[, -1], wikidata_content_statement_item[, 1])
      return(dygraph(wikidata_content_statement_item,
                     main = "Statements per Item",
                     ylab = "Statements") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_statement_item", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         stackedGraph = TRUE,
                         plotter = barChartPlotter) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_content_labels_item_plot <- renderDygraph({
      wikidata_content_labels_item<- xts(wikidata_content_labels_item[, -1], wikidata_content_labels_item[, 1])
      return(dygraph(wikidata_content_labels_item,
                     main = "Labels per Item",
                     ylab = "Labels") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_labels_item", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         stackedGraph = TRUE,
                         plotter = barChartPlotter) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_content_descriptions_item_plot <- renderDygraph({
      wikidata_content_descriptions_item<- xts(wikidata_content_descriptions_item[, -1], wikidata_content_descriptions_item[, 1])
      return(dygraph(wikidata_content_descriptions_item,
                     main = "Descriptions per Item",
                     ylab = "Descriptions") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_descriptions_item", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         stackedGraph = TRUE,
                         plotter = barChartPlotter) %>%
               dyCSS(css = "./assets/css/custom.css"))
    })
    output$wikidata_content_wikilinks_item_plot <- renderDygraph({
    wikidata_content_wikilinks_item<- xts(wikidata_content_wikilinks_item[, -1], wikidata_content_wikilinks_item[, 1])
    return(dygraph(wikidata_content_wikilinks_item,
                   main = "Wiki(m|p)edia links per item",
                   ylab = "Links") %>%
             dyLegend(width = 400, show = "always", labelsDiv = "legend_wikilinks_item", labelsSeparateLines = TRUE) %>%
             dyOptions(useDataTimezone = TRUE,
                       labelsKMB = TRUE,
                       stackedGraph = TRUE,
                       plotter = barChartPlotter) %>%
             dyCSS(css = "./assets/css/custom.css"))
    })
    output$metric_meta_quality1 <- renderInfoBox({
      metric_desc <- get_rdf_metadata("<http://wikiba.se/metrics#percentage_of_statements_with_a_non-Wikimedia_reference_as_of_a_given_month>")
      box_title <- paste0("Meta")
      box_value <- paste0(metric_desc)
      box(box_value, status = "info", width = 6, collapsible = TRUE)
    })
    output$metric_meta_quality2 <- renderInfoBox({
      metric_desc <- get_rdf_metadata("<http://wikiba.se/metrics#percentage_of_items_with_a_quality_score_according_to_scoring_algorithm_A,_...,_scoring_algorithm_Z_higher_than_0,_...,_1>")
      box_title <- paste0("Meta")
      box_value <- paste0(metric_desc)
      box(status = "info", box_value)
    })
    output$metric_meta_community_health <- renderInfoBox({
      metric_desc <- get_rdf_metadata("<http://wikiba.se/metrics#number_of_active_editors_who_make_5,_100_edits_in_given_month,_rolling_30_day_window>")
      box_title <- paste0("Meta")
      box_value <- paste0(metric_desc)
      box(width = 6, status = "primary", box_value)
    })
    output$metric_meta_partnerships <- renderInfoBox({
      metric_desc <- get_rdf_metadata("<http://wikiba.se/metrics#number_of_items_or_statements_contributed_by_partnership_A,_..._partnership_Z_in_a_given_month,_broken_down_by_quality,_edited_statements,_setup_length,_community_onboarding_time,_technical_audit,_size_of_institution,_usage_of_data_after_launch>")
      box_title <- paste0("Meta")
      box_value <- paste0(metric_desc)
      box(width = 6, status = "primary", box_value)
    })
    output$metric_meta_external_use <- renderInfoBox({
      metric_desc <- get_rdf_metadata("<http://wikiba.se/metrics#number_of_queries_by_non-browser_app_A,_...,_non-browser_app_Z_in_given_month,_rolling_30_day_window>")
      box_title <- paste0("Meta")
      box_value <- paste0(metric_desc)
      box(width = 6, status = "primary", box_value)
    })

    # http://wikiba.se/metrics#Internal_Use
    output$metric_meta_internal_use_objects1 <- renderUI({
      box(title = "Individual", width = 12, status = "primary", tags$a(href = internal_use_objs[1], internal_use_objs[1]))
    })
    output$metric_meta_internal_use1 <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",internal_use_objs[1],">"))
      box(title = "Comment", width = 6, status = "info", metric_desc[1])
    })
    output$metric_meta_internal_use_objects2 <- renderUI({
      box(title = "Individual", width = 12, status = "primary", tags$a(href = internal_use_objs[2], internal_use_objs[2]))
    })
    output$metric_meta_internal_use2 <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",internal_use_objs[2],">"))
      box(title = "Comment",width = 6, status = "info", metric_desc[1])
    })
})
