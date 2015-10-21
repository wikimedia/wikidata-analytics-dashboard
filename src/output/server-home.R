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
  datatable(dt_join[2:5], class = "display compact", colnames = c("Property", "Value", "Delta"), options = list(dom = 't', columnDefs = list(list(width='10%', targets = c(0)), list(width='30%', targets = c(1)), list(width='30%', targets = c(2)))), caption = paste0("Statistics for ", dt_join[1,V1])) %>%
  formatCurrency(2:3, currency = "", interval = 3, mark = ",") %>%
  formatStyle(3, color = styleInterval(cuts, c("red", "green"))
))

#Latest DataValues Table
latest_dv <- data.frame(tail(sparql1,2), tail(sparql2,2), tail(sparql3,2))
data_values_latest <- data.table(latest_dv[order(latest_dv$Sys.Date.., decreasing =TRUE),])
dv_latest <- setnames(data_values_latest, c("Date", "GlobecoordinateValue", "date.1", "TimeValue", "date.2", "QuantityValue"))
dv_latest <- dv_latest[, list(Date, GlobecoordinateValue, TimeValue, QuantityValue)]
dv_delta <- dv_latest[, list(Date, GlobecoordinateValue=diff(GlobecoordinateValue)*-1, TimeValue=diff(TimeValue)*-1, QuantityValue=diff(QuantityValue)*-1)]
dv_delta_out <- t(dv_delta[1])
dv_latest_out <- t(dv_latest[1])
dv_out <- data.table(dv_latest_out, keep.rownames=TRUE)
dv_out$id <- seq_len(nrow(dv_out))
dv_delta_out <- data.table(dv_delta_out, keep.rownames=TRUE)
dv_delta_out$id <- seq_len(nrow(dv_delta_out))
setkey(dv_out, id)
setkey(dv_delta_out, id)
dv_join <- dv_out[dv_delta_out]
dv_join <- dv_join[,.SD,.SDcols=c(1:2,5)]
cuts <- 0
output$wikidata_daily_datavalues_table <- DT::renderDataTable(
  datatable(dv_join[2:4], class = "display compact", colnames = c("Property", "Value", "Delta"), options = list(dom = 't', columnDefs = list(list(width='10%', targets = c(0)), list(width='30%', targets = c(1)), list(width='30%', targets = c(2)))), caption = paste0("WDQS Sourced Statistics for ", dv_join[1,V1])) %>%
    formatCurrency(2:3, currency = "", interval = 3, mark = ",") %>%
    formatStyle(3, color = styleInterval(cuts, c("red", "green"))
    ))


