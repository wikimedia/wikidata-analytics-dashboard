download_set <- function(file, uri = data_uri){
      location <- paste0(uri, file)
      con <- url(location)
      set <- readr::read_delim(con, delim = "\t")
      return(set)
}

get_csv_from_api <- function(params, uri = graphite_api_uri){
  location <- paste0(uri, params)
  con <- url(location)
  set <- readr::read_csv(con, col_names = c("desc", "date", "value"), col_types = list(col_character(), col_character(), col_double()))
  return(set)
}

get_local_set <- function(file, uri = data_uri){
  location <- paste0(uri, file)
  set <- readr::read_delim(location, delim = "\t")
  return(set)
}

#Create a dygraph using standard format.
make_dygraph <- function(data, x, y, title, is_single = FALSE, legend_name = NULL, use_si = TRUE, smoothing = "day") {
  data <- xts(data[, -1], order.by = data[, 1])
  return(dygraph(data, main = title, xlab = x, ylab = y) %>%
           dySeries("V1", label = y) %>%
           dyLegend(width = 400, show = "always") %>%
           dyOptions(strokeWidth = 3,
                     colors = brewer.pal(max(3, ncol(data)), "Set1"),
                     drawPoints = FALSE, pointSize = 3, labelsKMB = use_si,
                     includeZero = TRUE) %>%
           dyCSS(css = "./assets/css/custom.css"))
}

# Computes a median absolute deviation
mad <- function(x) {
  median(abs(x - median(x)))
}

compress <- function(x, round.by = 2) {
  # by StackOverflow user 'BondedDust' : http://stackoverflow.com/a/28160474
  div <- findInterval(as.numeric(gsub("\\,", "", x)),
                      c(1, 1e3, 1e6, 1e9, 1e12) )
  paste(round( as.numeric(gsub("\\,","",x))/10^(3*(div-1)), round.by),
        c("","K","M","B","T")[div], sep = "" )
}

# Conditional icon for widget.
# Returns arrow-up icon on true (if true_direction is 'up'), e.g. load time % change > 0
cond_icon <- function(condition, true_direction = "up") {

  if (true_direction == "up") {
    return(icon(ifelse(condition, "arrow-up", "arrow-down")))
  }

  return(icon(ifelse(condition, "arrow-down", "arrow-up")))
}

# Conditional color for widget
# Returns 'green' on true, 'red' on false, e.g. api usage % change > 0
#                                               load time % change < 0
cond_color <- function(condition, true_color = "green") {
  if(is.na(condition)){
    return("black")
  }

  colours <- c("green","red")
  return(ifelse(condition, true_color, colours[!colours == true_color]))
}

# Allows very quickly to get half a vector:
half <- function(x, which = c("top", "bottom")) {
  if (which == "top") {
    return(head(x, n = length(x)/2))
  }
  return(tail(x, n = length(x)/2))
}

# Uses ggplot2 to create a pie chart in bar form. (Will look up actual name)
gg_prop_bar <- function(data, cols) {
  # `cols` = list(`item`, `prop`, `label`)
  data$text_position <- cumsum(data[[cols$prop]]) + (c(0, cumsum(data[[cols$prop]])[-nrow(data)]) - cumsum(data[[cols$prop]]))/2
  ggplot(data, aes_string(x = 1, fill = cols$item)) +
    geom_bar(aes_string(y = cols$prop), stat="identity") +
    scale_fill_discrete(guide = FALSE, expand = c(0,0)) +
    scale_y_continuous(expand = c(0,0)) +
    scale_x_continuous(expand = c(0,0)) +
    labs(x = NULL, y = NULL) +
    coord_flip() +
    theme_bw() +
    theme(axis.ticks = element_blank(),
          axis.text = element_blank(),
          axis.title = element_blank(),
          plot.margin = grid::unit(c(0, 0, -0.5, -0.5), "lines"),
          panel.margin = grid::unit(0, "lines")) +
    geom_text(aes_string(label = cols$label,
                  y = "text_position",
                  x = 1))
}

# Calculates percent change either in `x` or from `x` to `y`
percent_change <- function(x, y = NULL) {
  if(is.null(y)) {
    return(100 * (x - c(NA, x[-length(x)])) / c(NA, x[-length(x)]))
  }
  return(100 * (y - x) / x)
}

# It's fairly common to need to grab the last N [whatever] of values.
# The problem with using tail() for this comes in the case where (perhaps
# due to backfilling) the last rows are not actually the last rows. This
# function will provide a 'safe' tail mechanism.
safe_tail <- function(x, n, silent = TRUE) {
  if (!is.vector(x) && !is.data.frame(x)) {
    stop("safe_trail() only works with vectors and data frames.")
  }
  # \code{silent} suppresses messages which may be used for debugging
  if (is.vector(x)) {
    return(tail(sort(x), n))
  }
  # Intelligently figure out which column is the date/timestamp column (in case it's not the first column):
  timestamp_column <- names(x)[sapply(x, class) %in% c("Date", "POSIXt", "POSIXlt", "POSIXct")]
  if (length(timestamp_column) == 0) {
    if (!silent) {
      message("No date/timestamp column detected for this dataset. It'd be faster to use tail().")
    }
    return(tail(x, n))
  }
  if (length(timestamp_column) > 1) warning("More than one date/timestamp column detected. Defaulting to the first one.")
  if (!silent) {
    message("Sorting by the date/timestamp column before returning the bottom ", n, " rows.")
  }
  return(tail(x[order(x[[timestamp_column[1]]]), ], n))
}

barChartPlotter <- "function barChartPlotter(e) {
  var ctx = e.drawingContext;
  var points = e.points;
  var y_bottom = e.dygraph.toDomYCoord(0);  // see http://dygraphs.com/jsdoc/symbols/Dygraph.html#toDomYCoord

  // This should really be based on the minimum gap
  var bar_width = 2/3 * (points[1].canvasx - points[0].canvasx);
  ctx.fillStyle = e.color;

  // Do the actual plotting.
  for (var i = 0; i < points.length; i++) {
    var p = points[i];
    var center_x = p.canvasx;  // center of the bar

    ctx.fillRect(center_x - bar_width / 2, p.canvasy,
                 bar_width, y_bottom - p.canvasy);
    ctx.strokeRect(center_x - bar_width / 2, p.canvasy,
                   bar_width, y_bottom - p.canvasy);
  }
}"

get_rdf_metadata <- function(subj, pred) {
  comment = sparql.rdf(metrics_model, paste("SELECT DISTINCT ?o WHERE { ",subj, pred," ?o}"))
  return(comment)
}

get_rdf_individuals <- function(obj) {
  individuals = sparql.rdf(metrics_model, paste("SELECT ?s WHERE { ?s ?p ",obj,"}"))
  return(individuals)
}

dyVisibility <- function (dygraph, visibility = TRUE){
  dygraph$x$attrs$visibility <- visibility
  dygraph
}

standard_comment_box <- function(value) {
  return(box(title = "comment", width = 6, status = "info", value))
}

standard_individual_box <- function(value) {
  return(box(title = "Individual", width = 12, status = "primary", tags$a(href = value, value)))
}

standard_seeAlso_box <- function(href, value) {
  return(box(title = "seeAlso", width = 6, status = "primary", tags$a(value, href=href, target="_blank")))
}

internal_reference_box <- function(dv, href, value) {
  return(box(title = "seeAlso", width = 6, status = "primary", tags$a(href=href, 'data-toggle'='tab','data-value'=dv, value)))
}

dygraph_from_param_file <- function(chart_title){
  dt_spql_file <- data.table(params_file)
  return(dygraph(dt_spql_file,
                 main = chart_title,
                 ylab = "") %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     fillGraph = TRUE,
                     strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
           dyCSS(css = custom_css))
}

dygraph_from_param_property <- function(){
  dt_getclaims_file <- data.table(wikidata_daily_getclaims_property_use)
  setkey(dt_getclaims_file, property)
  dt_getclaims_property <- dt_getclaims_file[params_property]
  dt_getclaims_property <- dt_getclaims_property[,.SD,.SDcols=c(1,3)]
  title_query <- get_property_label_query(params_property)
  pfx <- get_property_label_prefixes()
  title_doc <- get_sparql_result(wdqs_uri, pfx, title_query)
  title <- get_dataframe_from_xml_result(title_doc, "//sq:literal")
  return(dygraph(dt_getclaims_property,
                 main = paste0(params_property, " : ", title$text),
                 ylab = "") %>%
           dyOptions(useDataTimezone = TRUE,
                     labelsKMB = TRUE,
                     fillGraph = TRUE,
                     strokeWidth = 2, colors = brewer.pal(5, "Set2")[5:1]) %>%
           dyCSS(css = custom_css))
}

get_property_label_query <- function(params_property){
  query = curl_escape(paste0("SELECT distinct ?o WHERE {wd:",params_property, " ?p ?o
    SERVICE wikibase:label {
      bd:serviceParam wikibase:language \"en\" .
      wd:",params_property," rdfs:label ?o
    }
  }"))
  return(query)
}

get_property_label_prefixes <- function(){
  prefixes <- "PREFIX%20wd%3A%20%3Chttp%3A%2F%2Fwww.wikidata.org%2Fentity%2F%3EPREFIX%20wikibase%3A%20%3Chttp%3A%2F%2Fwikiba.se%2Fontology%23%3EPREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E"
  return(prefixes)
}

get_property_list_query <- function(){
  query = curl_escape("SELECT ?s ?o WHERE {?s ?p wikibase:Property .
SERVICE wikibase:label {
      bd:serviceParam wikibase:language \"en\" .
      ?s rdfs:label ?o}}")
  return(query)
}

get_item_list_query <- function(){
  query = curl_escape("SELECT ?s ?o WHERE {?s ?p wikibase:Item} LIMIT 1000000")
  return(query)
}

get_sparql_result <- function(uri = wdqs_uri, prefix, query) {
  xml_result <- readLines(curl(paste0(uri, prefix, query)))
  doc = xmlParse(xml_result)
  return(doc)
}

get_dataframe_from_xml_result <- function(doc, qname) {
  result = xmlToDataFrame(nodes = getNodeSet(doc, qname, c(sq = "http://www.w3.org/2005/sparql-results#")))
  return(result)
}

get_estimated_card_from_prop_predicate <- function(uri = estcard.uri, predicate, literal) {
  xml_result <- getForm(uri, p=paste0("<http://www.wikidata.org/", predicate, literal, ">"))
  doc = xmlParse(xml_result)
  result = xpathApply(doc, "//data[@rangeCount]", xmlGetAttr, "rangeCount")
  return(result)
}

get_statements_per_item <- function(uri = wdmrdf_uri, literal) {
  query <- paste0("SELECT (count(distinct(?o)) AS ?ocount)   WHERE {
 <", literal,  "> ?p ?o FILTER(STRSTARTS(STR(?p), \"http://www.wikidata.org/prop/direct\"))
}")
  esc_query <- curl_escape(query)
  prefix = ""
  doc <- get_sparql_result(uri, prefix, esc_query)
  result <- get_dataframe_from_xml_result(doc, "//sq:literal")
  return(result)
}