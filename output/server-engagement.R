#Engagement Metrics

# http://wikiba.se/metrics#Edits
output$wikidata_edits_plot <- renderDygraph({
  make_dygraph(wikidata_edits,
               "", "Edits", "Wikidata Edits")
})
output$editdelta <- renderInfoBox({
  wikidata_edits_30day <- wikidata_edits[which(wikidata_edits$date > Sys.Date() - 30),]
  edits_first <- tail(wikidata_edits_30day[order(wikidata_edits_30day$date, decreasing =TRUE),],1)
  edits_current <- head(wikidata_edits_30day[order(wikidata_edits_30day$date, decreasing =TRUE),],1)
  period_last <- format(edits_first[1])
  period_current <- format(edits_current[1])
  edits_delta <- edits_current$count - edits_first$count
  edits_last_total <- edits_current$count
  edits_delta_percentage <- percent(edits_delta/edits_last_total)
  form_edits <- prettyNum(edits_delta, big.mark=",")
  box_title <- paste0("Edit 30 Day Delta")
  box_subtitle <- paste0(period_last, " to ", period_current)
  box_value <- paste0(form_edits, " | ", edits_delta_percentage)
  infoBox(box_title, box_value, box_subtitle, icon = icon("arrow-up"),
          color = "green"
  )
})
output$metric_meta_edits <- renderUI({
  box(title = "Individual", width = 6, status = "primary", tags$a(href = engagement_obj[1], engagement_obj[1]))
})
output$metric_meta_edits_datasource <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",engagement_obj[1],">"), "<http://wikiba.se/metrics#dataSourceURI>")
  box(title = "dataSourceURI", width = 6, status = "info", tags$a(href=metric_desc[1], metric_desc[1]))
})
output$metric_meta_edits_notes <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",engagement_obj[1],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  box(title = "Comment", width = 6, status = "info", metric_desc[1])
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
  metric_desc <- get_rdf_metadata(paste0("<",engagement_obj[2],">"), "<http://wikiba.se/metrics#dataSourceURI>")
  box(title = "dataSourceURI", width = 6, status = "info", tags$a(href=metric_desc[1], metric_desc[1]))
})
output$metric_meta_active_users_notes <- renderUI({
  metric_desc <- get_rdf_metadata(paste0("<",engagement_obj[2],">"), "<http://www.w3.org/2000/01/rdf-schema#comment>")
  box(title = "Comment", width = 6, status = "info", metric_desc[1])
})

# http://wikiba.se/metrics#Social_Media
wd_fb <- data.table(wikidata_facebook[order(wikidata_facebook$date, decreasing=TRUE),])
wd_gp <- data.table(wikidata_googleplus[order(wikidata_googleplus$date, decreasing=TRUE),])
wd_twitter <- data.table(wikidata_twitter[order(wikidata_twitter$date, decreasing=TRUE),])
setkey(wd_fb, date)
setkey(wd_gp, date)
setkey(wd_twitter, date)
wd_social <- wd_fb[wd_gp]
wd_social <- wd_social[wd_twitter]
wd_social <- setnames(wd_social, c("Date", "Facebook Likes", "Google + Followers", "Twitter Followers"))
output$wikidata_social_media_plot <- renderDygraph({
  return(dygraph(wd_social,
                 main = "Wikidata Social Media",
                 ylab = "") %>%
           dyLegend(width = 400, show = "always", labelsDiv = "legend_social_media", labelsSeparateLines = TRUE) %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     connectSeparatedPoints = TRUE,
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