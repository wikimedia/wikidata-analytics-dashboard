#Dependent libs
library(plyr)
library(readr)
library(xts)
library(reshape2)
library(RColorBrewer)
library(ggplot2)
library(toOrdinal)
library(lubridate)
library(magrittr)

#Utility functions for handling particularly common tasks
download_set <- function(location){
  location <- paste0("http://localhost/", location,
                     "?ts=", gsub(x = Sys.time(), pattern = "(-| )", replacement = ""))
  con <- url(location)
  return(readr::read_delim(con, delim = "\t"))
}

# Takes an untidy (read: dygraph-appropriate) dataset and adds
# columns for each variable consisting of the smoothed, averaged mean
smoother <- function(dataset, smooth_level = "day", rename = TRUE) {

  # Determine the names and levels of aggregation. By default
  # a smoothing level of "day" is assumed, which is no smoothing
  # whatsoever, and so the original dataset is returned.
  switch(smooth_level,
         moving_avg = {
           df <- apply(dataset[, -1, drop = FALSE], 2, function(x) {
             y <- xts(x, dataset[, 1])
             return(as.numeric(zoo::rollmean(x, k = 17, fill = NA)))
           }) %>% as.data.frame %>% cbind(timestamp = dataset[, 1], .)
           names(df) <- names(dataset)
           if (rename) names(df)[-1] <- paste(names(df)[-1], " (Moving average)")
           return(df)
         },
         week = {
           dataset$filter_1 <- lubridate::week(dataset[, 1])
           dataset$filter_2 <- lubridate::year(dataset[, 1])
           name_append <- ifelse(rename, " (Weekly average)", "")
         },
         month = {
           dataset$filter_1 <- lubridate::month(dataset[, 1])
           dataset$filter_2 <- lubridate::year(dataset[, 1])
           name_append <- ifelse(rename, " (Monthly average)", "")
         },
         {
           return(dataset)
         }
  )

  # If we're still here it was weekly or monthly. Calculate
  # the average for each unique permutation of filters

  result <- ddply(.data = dataset,
                  .variables = c("filter_1", "filter_2"),
                  .fun = function(df, name_append){

                    # Construct output names for the averages, compute those averages, and
                    # apply said names.
                    output_names <- paste0(names(df)[2:(ncol(df) - 2)], name_append)
                    holding <- apply(df[, 2:(ncol(df) - 2), drop = FALSE], 2, FUN = median) %>%
                      round %>% t %>% as.data.frame
                    names(holding) <- output_names

                    # Return the bound original values and averaged values
                    return(cbind(df[, 1, drop = FALSE], holding))
                  }, name_append = name_append)

  return(result[, !(names(result) %in% c("filter_1","filter_2"))])
}

#Create a dygraph using our standard format.
make_dygraph <- function(data, x, y, title, is_single = FALSE, legend_name = NULL, use_si = TRUE, smoothing = "day") {
  # cat("Making dygraph:", title, "\n"); # Debugging
  if (is_single) {
    data <- smoother(as.data.frame(data[, c(1, 3)]), smooth_level = smoothing)
    data <- xts(data[, 2], data[, 1])
    if (is.null(legend_name)) {
      names(data) <- "events"
    } else {
      names(data) <- legend_name
    }
  } else {
    data %<>% smoother(smooth_level = smoothing)
    data <- xts(data[, -1], order.by = data[, 1])
  }
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