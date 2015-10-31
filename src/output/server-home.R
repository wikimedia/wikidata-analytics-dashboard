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
dt_hrefs <- data.table(c("1", "#shiny-tab-wikidata_edits", "#shiny-tab-wikidata_active_users", "#shiny-tab-wikidata_pages", "#shiny-tab-wikidata_pages"))
dt_hrefs$id <- seq_len(nrow(dt_hrefs))
setkey(dt_hrefs, id)
setkey(dt_out, id)
setkey(dt_delta_out, id)
dt_join <- dt_out[dt_delta_out]
dt_join_hrefs <- dt_join[dt_hrefs]
dt_join_hrefs <- dt_join_hrefs[,.SD,.SDcols=c(1:2,5:6)]
cuts <- 0
output$wikidata_daily_summary_table <- DT::renderDataTable(
  datatable(dt_join_hrefs[2:5], class = "display compact", colnames = c("Object", "Count", "Delta", "Chart"),
            options = list(
              dom = 't',
              columnDefs = list(
                list(width='10%', targets = c(0)),
                list(width='30%', targets = c(1)),
                list(width='30%', targets = c(2)),
                list(targets = c(4), render = JS(
                  "function(data, type, row, meta) {",
                  "return '<a href=\"'+data+'\" data-toggle=\"tab\" data-value=\"'+data+'\">Chart</a>'",
                  "}")
                )
              )
            ),
            caption = paste0("Statistics for ", dt_join[1,V1])) %>%
            formatCurrency(2:3, currency = "", interval = 3, mark = ",") %>%
            formatStyle(3, color = styleInterval(cuts, c("red", "green"))
            )
  )

#Latest DataValues Table
latest_dv <- data.frame(tail(sparql1,2), tail(sparql2,2), tail(sparql3,2), tail(sparql13,2))
data_values_latest <- data.table(latest_dv[order(latest_dv$Sys.Date.., decreasing =TRUE),])
dv_latest <- setnames(data_values_latest, c("Date", "GlobecoordinateValue", "date.1", "TimeValue", "date.2", "QuantityValue", "date.3", "Wikimedia Categories" ))
dv_latest <- dv_latest[, list(Date, GlobecoordinateValue, TimeValue, QuantityValue, `Wikimedia Categories`)]
dv_delta <- dv_latest[, list(Date, GlobecoordinateValue=diff(GlobecoordinateValue)*-1, TimeValue=diff(TimeValue)*-1, QuantityValue=diff(QuantityValue)*-1, `Wikimedia Categories`=diff(`Wikimedia Categories`)*-1)]
dv_delta_out <- t(dv_delta[1])
dv_latest_out <- t(dv_latest[1])
dv_out <- data.table(dv_latest_out, keep.rownames=TRUE)
dv_out$id <- seq_len(nrow(dv_out))
dv_delta_out <- data.table(dv_delta_out, keep.rownames=TRUE)
dv_delta_out$id <- seq_len(nrow(dv_delta_out))
dv_hrefs <- data.table(c("1", "./?t=wikidata_rdf_graphs&file=spql1.tsv", "./?t=wikidata_rdf_graphs&file=spql2.tsv", "./?t=wikidata_rdf_graphs&file=spql3.tsv", "./?t=wikidata_rdf_graphs&file=spql13.tsv"))
dv_hrefs$id <- seq_len(nrow(dv_hrefs))
setkey(dv_hrefs, id)
setkey(dv_out, id)
setkey(dv_delta_out, id)
dv_join <- dv_out[dv_delta_out]
dv_join_hrefs <- dv_join[dv_hrefs]
dv_join_hrefs <- dv_join_hrefs[,.SD,.SDcols=c(1:2,5:6)]
cuts <- 0
output$wikidata_daily_datavalues_table <- DT::renderDataTable(
  datatable(dv_join_hrefs[2:5], class = "display compact", colnames = c("Object", "Count", "Delta", "Chart"),
            options = list(
              dom = 't',
              columnDefs = list(
                list(width='10%', targets = c(0)),
                list(width='30%', targets = c(1)),
                list(width='30%', targets = c(2)),
                list(targets = c(4), render = JS(
                  "function(data, type, row, meta) {",
                  "return '<a href=\"'+data+'\">Chart</a>'",
                  "}")
                )
              )
            ),
            caption = paste0("WDQS Sourced Statistics for ", dv_join[1,V1])) %>%
    formatCurrency(2:3, currency = "", interval = 3, mark = ",") %>%
    formatStyle(3, color = styleInterval(cuts, c("red", "green"))
    )
  )


