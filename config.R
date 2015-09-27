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

data_uri <- "http://localhost/data/"
source_data_uri <- "http://wdm-data.wmflabs.org/"
custom_css <- "./assets/css/custom.css"
metrics_rdf = "/srv/dashboards/shiny-server/wdm/assets/metrics.owl"
