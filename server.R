## Version 0.2.0
source("config.R")
source("model.R")
source("utils.R")

existing_date <- (Sys.Date()-1)

shinyServer(function(input, output) {

    if(Sys.Date() != existing_date){
      get_datasets()
      load_rdf_model()
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
      edits_latest <- cbind("Edits" = tail(wikidata_edits$edits, 2))
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
      box(title = "Individual", width = 6, status = "primary", tags$a(href = engagement_obj[1], engagement_obj[1]))
    })
    output$metric_meta_edits_datasource <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",engagement_obj[1],">"), "<http://wikiba.se/metrics#dataSourceFile>")
      box(title = "dataSourceFile", width = 6, status = "info", tags$a(href=paste0(source_data_uri, metric_desc[1]), metric_desc[1]))
    })
    output$metric_meta_edits_notes <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",engagement_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#isDefinedBy>")
      box(title = "Definition", width = 6, status = "info", metric_desc[1])
    })
    # http://wikiba.se/metrics#Active_Users
    output$wikidata_active_users_plot <- renderDygraph({
      make_dygraph(wikidata_active_users,
                   "", "Active Users", "Wikidata Active Users", legend_name = "active users")
    })
    output$metric_meta_active_users <- renderUI({
      box(title = "Individual", width = 6, status = "primary", tags$a(href = engagement_obj[2], engagement_obj[2]))
    })
    output$metric_meta_active_users_datasource <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",engagement_obj[2],">"), "<http://wikiba.se/metrics#dataSourceFile>")
      box(title = "dataSourceFile", width = 6, status = "info", tags$a(href=paste0(source_data_uri, metric_desc[1]), metric_desc[1]))
    })
    output$metric_meta_active_users_notes <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",engagement_obj[2],">"), "<http://www.w3.org/2000/01/rdf-schema#isDefinedBy>")
      box(title = "Definition", width = 6, status = "info", metric_desc[1])
    })
    # http://wikiba.se/metrics#Social_Media
    output$wikidata_social_media_plot <- renderDygraph({
      wikidata_social_media <- xts(wikidata_social_media[, -1], wikidata_social_media[, 1])
      return(dygraph(wikidata_social_media,
                     main = "Wikidata Social Media",
                     ylab = "Lists") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_social_media", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = custom_css))
    })
    # http://wikiba.se/metrics#Mailing_Lists
    output$wikidata_mailing_lists_plot <- renderDygraph({
      wikidata_mailing_lists <- xts(wikidata_mailing_lists[, -1], wikidata_mailing_lists[, 1])
      return(dygraph(wikidata_mailing_lists,
                     main = "Wikidata Mailing Lists Subscribers",
                     ylab = "Subscribers") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_lists", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = custom_css))
    })
    output$wikidata_mailing_lists_messages_plot <- renderDygraph({
      wikidata_mailing_lists_messages <- xts(wikidata_mailing_lists_messages[, -1], wikidata_mailing_lists_messages[, 1])
      return(dygraph(wikidata_mailing_lists_messages,
                     main = "Wikidata Mailing Lists Messages",
                     ylab = "Messages") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_lists_messages", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = custom_css))
    })
    # http://wikiba.se/metrics#Pages
    output$wikidata_pages_plot <- renderDygraph({
      make_dygraph(wikidata_pages,
                   "", "Pages", "Wikidata Pages", legend_name = "pages")
    })
    output$metric_meta_pages <- renderUI({
      box(title = "Individual", width = 6, status = "primary", tags$a(href = content_obj[13], content_obj[13]))
    })
    output$metric_meta_pages_datasource <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",content_obj[13],">"), "<http://wikiba.se/metrics#dataSourceFile>")
      box(title = "dataSourceFile", width = 6, status = "info", tags$a(href=paste0(source_data_uri, metric_desc[1]), metric_desc[1]))
    })
    output$metric_meta_pages_notes <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",content_obj[13],">"), "<http://www.w3.org/2000/01/rdf-schema#isDefinedBy>")
      box(title = "Definition", width = 6, status = "info", metric_desc[1])
    })
    # http://wikiba.se/metrics#Items
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
               dyCSS(css = custom_css))
    })
    output$metric_meta_items <- renderUI({
      box(title = "Individual", width = 6, status = "primary", tags$a(href = content_obj[5], content_obj[5]))
    })
    output$metric_meta_items_datasource <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",content_obj[5],">"), "<http://wikiba.se/metrics#dataSourceFile>")
      box(title = "dataSourceFile", width = 6, status = "info", tags$a(href=paste0(source_data_uri, metric_desc[1]), metric_desc[1]))
    })
    output$metric_meta_items_notes <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",content_obj[5],">"), "<http://www.w3.org/2000/01/rdf-schema#isDefinedBy>")
      box(title = "Definition", width = 6, status = "info", metric_desc[1])
    })
    # http://wikiba.se/metrics#Properties
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
               dyCSS(css = custom_css))
    })
    output$metric_meta_properties <- renderUI({
      box(title = "Individual", width = 6, status = "primary", tags$a(href = content_obj[9], content_obj[9]))
    })
    output$metric_meta_properties_datasource <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",content_obj[9],">"), "<http://wikiba.se/metrics#dataSourceFile>")
      box(title = "dataSourceFile", width = 6, status = "info", tags$a(href=paste0(source_data_uri, metric_desc[1]), metric_desc[1]))
    })
    output$metric_meta_properties_notes <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",content_obj[9],">"), "<http://www.w3.org/2000/01/rdf-schema#isDefinedBy>")
      box(title = "Definition", width = 6, status = "info", metric_desc[1])
    })
    # http://wikiba.se/metrics#References_Overview
    output$wikidata_references_overview_plot <- renderDygraph({
      wikidata_references_overview<- xts(wikidata_references_overview[, -1], wikidata_references_overview[, 1])
      return(dygraph(wikidata_references_overview,
                     main = "Wikidata References Overview",
                     ylab = "") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = custom_css))
    })
    output$metric_meta_references_overview <- renderUI({
      box(title = "Individual", width = 6, status = "primary", tags$a(href = content_obj[1], content_obj[1]))
    })
    output$metric_meta_references_overview_datasource <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",content_obj[1],">"), "<http://wikiba.se/metrics#dataSourceFile>")
      box(title = "dataSourceFile", width = 6, status = "info", tags$a(href=paste0(source_data_uri, metric_desc[1]), metric_desc[1]))
    })
    output$metric_meta_references_overview_notes <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",content_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#isDefinedBy>")
      box(title = "Definition", width = 6, status = "info", metric_desc[1])
    })
    # http://wikiba.se/metrics#Referenced_Statements_by_Type
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
               dyCSS(css = custom_css))
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
               dyCSS(css = custom_css))
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
               dyCSS(css = custom_css))
    })
    # http://wikiba.se/metrics#References_by_Type
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
               dyCSS(css = custom_css))
    })
    # http://wikiba.se/metrics#Statement_Ranks
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
               dyCSS(css = custom_css))
    })
    # http://wikiba.se/metrics#Statements_per_Item
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
               dyCSS(css = custom_css))
    })
    # http://wikiba.se/metrics#Labels_per_Item
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
               dyCSS(css = custom_css))
    })
    # http://wikiba.se/metrics#Descriptions_per_Item
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
               dyCSS(css = custom_css))
    })
    # http://wikiba.se/metrics#Wikimedia_links_per_item
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
             dyCSS(css = custom_css))
    })
    # http://wikiba.se/metrics#Community_Health
    output$metric_meta_community_health_objects <- renderUI({
      box(title = "Individual", width = 12, status = "primary", tags$a(href = community_health_obj[1], community_health_obj[1]))
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
      box(title = "Comment", width = 6, status = "info", metric_desc[1])
    })
    # http://wikiba.se/metrics#Quality
    output$metric_meta_quality_objects1 <- renderUI({
      box(title = "Individual", width = 12, status = "primary", tags$a(href = quality_obj[1], quality_obj[1]))
    })
    output$metric_meta_quality1 <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",quality_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
      box(title = "Comment", width = 6, status = "info", metric_desc[1])
    })
    output$metric_meta_quality_objects2 <- renderUI({
      box(title = "Individual", width = 12, status = "primary", tags$a(href = quality_obj[2], quality_obj[2]))
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
    output$metric_meta_quality2 <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",quality_obj[2],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
      box(title = "Comment",width = 6, status = "info", metric_desc[1])
    })
    # http://wikiba.se/metrics#Partnerships
    output$metric_meta_partnerships_objects <- renderUI({
      box(title = "Individual", width = 12, status = "primary", tags$a(href = partnerships_obj[1], partnerships_obj[1]))
    })
    output$metric_meta_partnerships <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",partnerships_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
      box(title = "Comment", width = 6, status = "info", metric_desc[1])
    })
    # http://wikiba.se/metrics#External_Use
    output$metric_meta_external_use_objects <- renderUI({
      box(title = "Individual", width = 12, status = "primary", tags$a(href = external_use_obj[1], external_use_obj[1]))
    })
    output$metric_meta_external_use <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",external_use_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
      box(title = "Comment", width = 6, status = "info", metric_desc[1])
    })

    # http://wikiba.se/metrics#Internal_Use
    output$metric_meta_internal_use_objects1 <- renderUI({
      box(title = "Individual", width = 12, status = "primary", tags$a(href = internal_use_obj[1], internal_use_obj[1]))
    })
    output$metric_meta_internal_use1 <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",internal_use_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
      box(title = "Comment", width = 6, status = "info", metric_desc[1])
    })
    output$metric_meta_internal_use_objects2 <- renderUI({
      box(title = "Individual", width = 12, status = "primary", tags$a(href = internal_use_obj[2], internal_use_obj[2]))
    })
    output$metric_meta_internal_use2 <- renderUI({
      metric_desc <- get_rdf_metadata(paste0("<",internal_use_obj[2],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
      box(title = "Comment",width = 6, status = "info", metric_desc[1])
    })
})
