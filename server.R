## Version 0.2.0
source("config.R")
source("model.R")
source("utils.R")

existing_date <- (Sys.Date()-1)

shinyServer(function(input, output, session) {

    if(Sys.Date() != existing_date){
      get_local_datasets()
      get_remote_datasets()
      load_rdf_model()
      get_rdf_objects()
      existing_date <<- Sys.Date()
    }

    observeEvent(input$switchtab, {
        updateTabItems(session, "tabs", input$switchtab)
    })
    #Home
    latest_frame <- data.frame(tail(wikidata_edits,1), tail(wikidata_active_users,1), tail(wikidata_pages,1),tail(wikidata_gooditems,1),tail(wikidata_facebook,1),tail(wikidata_googleplus,1),tail(wikidata_twitter,1),tail(wikidata_identica,1),tail(wikidata_irc,1))
    dt_latest <- data.table(latest_frame)
    dt_latest <- setnames(dt_latest, c("Date", "Edits", "date.1", "Active Users", "date.2", "Pages", "date.3", "Content Pages", "date.4", "Facebook Likes", "date.5", "Google+ Followers", "date.6","Twitter Followers", "date.7","Identica Followers", "date.8","IRC"))
    dt_latest <- dt_latest[, list(Date, Edits, `Active Users`,Pages,`Content Pages`,`Facebook Likes`,`Google+ Followers`,`Twitter Followers`,`Identica Followers`,IRC)]
    df_out <- t(dt_latest)
    output$wikidata_daily_summary_table <- renderDataTable(
      datatable(df_out, class = "display compact", colnames = c("Property", "Value"), caption = "Statistics Today"))
    # http://wikiba.se/metrics#RecentEdits
    wikidata_recent_edits <- wikidata_edits[which(wikidata_edits$date > existing_date - 7),]
    df_recent_edits <- wikidata_recent_edits[order(wikidata_recent_edits$date, decreasing =TRUE),]
    dt_recent_edits <- data.table(df_recent_edits)
    output$wikidata_daily_edits_delta_plot <- renderDygraph({
      wikidata_daily_edits_delta <- dt_recent_edits[, list(date, count, diff_count=diff(count)*-1)]
      return(dygraph(wikidata_daily_edits_delta,
                     main = "Wikidata Edits/Day Last 7 Days",
                     ylab = "") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_daily_site", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = custom_css) %>%
               dyVisibility(visibility=c(input$checkbox_total_edits, TRUE)))
    })
    # http://wikiba.se/metrics#RecentPages
    df_pages_ordered <- wikidata_pages[order(wikidata_pages$date, decreasing =TRUE),]
    df_recent_pages <- df_pages_ordered[1:11,]
    df_gooditems_ordered <- wikidata_gooditems[order(wikidata_gooditems$date, decreasing =TRUE),]
    df_recent_gooditems <- df_gooditems_ordered[1:11,]
    df_recent_content <- data.frame(df_recent_pages, df_recent_gooditems)
    dt_recent_content <- data.table(df_recent_content)
    dt_recent_content <- dt_recent_content[, list(date, count, count.1)]
    output$wikidata_daily_pages_delta_plot <- renderDygraph({
      wikidata_daily_pages_delta <- dt_recent_content[, list(date, count, diff_pages=diff(count)*-1, count.1, diff_contentpages=diff(count.1)*-1)]
      return(dygraph(wikidata_daily_pages_delta,
                     main = "Wikidata New Pages/Day Last 7 Days",
                     ylab = "") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_daily_pages", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         fillGraph = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = custom_css) %>%
               dyVisibility(visibility=c(input$checkbox_total_pages, TRUE, input$checkbox_total_gooditems, TRUE)))
    })
    # http://wikiba.se/metrics#RecentUsers
    wikidata_recent_users <- wikidata_active_users[which(wikidata_active_users$date > existing_date - 7),]
    df_recent_users <- wikidata_recent_users[order(wikidata_recent_users$date, decreasing =TRUE),]
    dt_recent_users <- data.table(df_recent_users)
    output$wikidata_daily_users_delta_plot <- renderDygraph({
      wikidata_daily_users_delta <- dt_recent_users[, list(date, count, diff_count=diff(count)*-1)]
      return(dygraph(wikidata_daily_users_delta,
                     main = "Wikidata New Users/Day Last 7 Days",
                     ylab = "") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_daily_users", labelsSeparateLines = TRUE) %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = custom_css) %>%
               dyVisibility(visibility=c(input$checkbox_total_users, TRUE)))
    })
    # http://wikiba.se/metrics#Social
    wikidata_recent_social <- data.frame(wikidata_facebook, wikidata_googleplus, wikidata_twitter, wikidata_identica, wikidata_irc)
    wikidata_recent_social <- wikidata_recent_social[which(wikidata_recent_social$date > existing_date - 360),]
    dt_recent_social <- data.table(wikidata_recent_social)
    dt_recent_social <- dt_recent_social[, list(date, likes, followers, followers.1, followers.2, members)]
    output$wikidata_daily_social_plot <- renderDygraph({
     return(dygraph(dt_recent_social,
                     main = "Wikidata Social Media",
                     ylab = "") %>%
               dyLegend(width = 400, show = "always", labelsDiv = "legend_daily_social", labelsSeparateLines = TRUE) %>%
               dySeries("likes", label = "Facebook") %>%
               dySeries("followers", label = "Google+") %>%
               dySeries("followers.1", label = "Twitter") %>%
               dySeries("followers.2", label = "Identica") %>%
               dySeries("members", label = "IRC") %>%
               dyOptions(useDataTimezone = TRUE,
                         labelsKMB = TRUE,
                         strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
               dyCSS(css = custom_css))
    })
    # http://wikiba.se/metrics#GetClaimsPropertyUse
    output$metric_meta_getclaims_title <- renderUI({
      first_sample <- head(wikidata_daily_getclaims_property_use$date, 1)
      last_sample <- tail(wikidata_daily_getclaims_property_use$date, 1)
      metric_desc <- "Aggregate getClaim Property Use count"
      metric_range <- paste0("From ", first_sample, " To ", last_sample)
      box(title = "Definition", width = 6, status = "info", metric_desc, HTML("<br/>"), metric_range)
    })
    aggr_props <- aggregate(wikidata_daily_getclaims_property_use$count, by=list(wikidata_daily_getclaims_property_use$property), FUN = sum)
    aggr_props_ordered <- aggr_props[order(aggr_props$x, decreasing = TRUE),]
    output$wikidata_daily_getclaims_property_use_table <-renderDataTable(aggr_props_ordered, options = list(pageLength = 50))
    # http://wikiba.se/metrics#Edits
    output$wikidata_edits_plot <- renderDygraph({
      make_dygraph(wikidata_edits,
                   "", "Edits", "Wikidata Edits")
    })
    output$editdelta <- renderInfoBox({
      wikidata_edits_30day <- wikidata_edits[which(wikidata_edits$date > existing_date - 30),]
      edits_first <- tail(wikidata_edits_30day[order(wikidata_edits_30day$date, decreasing =TRUE),],1)
      edits_current <- head(wikidata_edits_30day[order(wikidata_edits_30day$date, decreasing =TRUE),],1)
      period_last <- format(edits_first[1])
      period_current <- format(edits_current[1])
      edits_delta <- edits_current$count - edits_first$count
      edits_last_total <- edits_current$count
      edits_delta_percentage <- percent(edits_delta/edits_last_total)
      form_edits <- prettyNum(edits_delta, big.mark=",")
      box_title <- paste0("Edit 30 Day Delta")
      box_subtitle <- paste0(period_current, " to ", period_last)
      box_value <- paste0(form_edits, " | ", edits_delta_percentage)
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
               dyCSS(css = custom_css) %>%
               dyVisibility(visibility=c(TRUE, TRUE, TRUE, TRUE, input$checkbox_ref_itemlink)))
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
               dyCSS(css = custom_css)  %>%
              dyVisibility(visibility=c(TRUE, input$checkbox_normal_rank, TRUE)))
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
      standard_seeAlso_box(metric_desc[1])
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
      standard_seeAlso_box(metric_desc[1])
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
})
