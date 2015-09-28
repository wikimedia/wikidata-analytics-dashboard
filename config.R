#Dependent libs
library(plyr)
library(readr)
library(xts)
library(reshape2)
library(RColorBrewer)
library(ggplot2)
library(scales)
library(toOrdinal)
library(lubridate)
library(magrittr)
library(curl)
library(rrdf)
library(data.table)
data_uri <- "http://localhost/data/"
source_data_uri <- "http://wdm-data.wmflabs.org/data/"
agg_data_uri <- "http://datasets.wikimedia.org/aggregate-datasets/wikidata/"
custom_css <- "./assets/css/custom.css"
metrics_rdf = "/srv/dashboards/shiny-server/wdm/assets/metrics.owl"
