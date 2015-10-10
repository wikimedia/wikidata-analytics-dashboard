#Home

#Latest Metrics Table
latest_frame <- data.frame(tail(wikidata_edits,2), tail(wikidata_active_users,2), tail(wikidata_pages,2),tail(wikidata_gooditems,2))
dt_latest <- data.table(latest_frame[order(latest_frame$date, decreasing =TRUE),])
dt_latest <- setnames(dt_latest, c("Date", "Edits", "date.1", "Active Users", "date.2", "Pages", "date.3", "Content Pages"))
dt_latest <- dt_latest[, list(Date, Edits, `Active Users`,Pages,`Content Pages`)]
dt_delta <- dt_latest[, list(Date, Edits=diff(Edits)*-1, `Active Users`=diff(`Active Users`)*-1, Pages=diff(Pages)*-1,`Content Pages`=diff(`Content Pages`)*-1)]
dt_delta_out <- t(dt_delta[1])
dt_latest_out <- t(dt_latest[1])
dt_out <- data.table(dt_latest_out, keep.rownames=TRUE)
dt_out$id <- seq_len(nrow(dt_out))
dt_delta_out <- data.table(dt_delta_out, keep.rownames=TRUE)
dt_delta_out$id <- seq_len(nrow(dt_delta_out))
setkey(dt_out, id)
setkey(dt_delta_out, id)
dt_join <- dt_out[dt_delta_out]
dt_join <- dt_join[,.SD,.SDcols=c(1:2,5)]
cuts <- 0
output$wikidata_daily_summary_table <- DT::renderDataTable(
  datatable(dt_join[2:5], class = "display compact", colnames = c("Property", "Value", "Delta"), caption = paste0("Statistics for ", dt_join[1,V1])) %>%
  formatCurrency(2:3, currency = "", interval = 3, mark = ",") %>%
  formatStyle(3, color = styleInterval(cuts, c("red", "green"))
))


