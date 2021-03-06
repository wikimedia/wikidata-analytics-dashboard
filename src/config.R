options(scipen = 500)

library(shiny)
library(shinydashboard)
library(dygraphs)
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
library(RCurl)
library(rrdf)
library(data.table)
library(DT)
library(XML)

base_uri <- "./"
data_uri <- paste0(base_uri, "data/")
sparql_data_uri <- paste0(data_uri, "sparql/")
graphite_api_uri <- "https://graphite.wikimedia.org/render/?target="
custom_css <- paste0(base_uri, "assets/css/custom.css")
metrics_rdf <- paste0(base_uri, "assets/metrics.owl")

source_data_uri <- "http://wdm-data.wmflabs.org/data/"
agg_data_uri <- "http://datasets.wikimedia.org/aggregate-datasets/wikidata/"
wdqs_uri <- "https://query.wikidata.org/bigdata/namespace/wdq/sparql?query="
wdmrdf_uri <- "https://wdm-rdf.wmflabs.org/bigdata/namespace/wdq/sparql?query="
estcard.uri <- "https://wdm-rdf.wmflabs.org/bigdata/namespace/wdq/sparql?ESTCARD"

