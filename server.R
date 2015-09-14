## Version 0.2.0
source("utils.R")

existing_date <- (Sys.Date()-1)

## Read in desktop data and generate means for the value boxes, along with a time-series appropriate form for
## dygraphs.
read_desktop <- function(){
  data <- download_set("wikidata-edits.tsv")
  wikidata_edits <<- data
  
  data <- download_set("wikidata-pages.tsv")
  wikidata_pages <<- data
  
  data <- download_set("wikidata-properties.tsv")
  wikidata_properties <<- data
  
  return(invisible())
}

shinyServer(function(input, output) {

  if(Sys.Date() != existing_date){
    read_desktop()
    existing_date <<- Sys.Date()
  }

  output$wikidata_edits_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_edits
    make_dygraph(wikidata_edits,
                 "Date", "Edits", "Wikidata Edits, by month",
                 smoothing = ifelse(smooth_level == "global", input$smoothing_global, smooth_level))
  })
  output$wikidata_pages_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_pages
    make_dygraph(wikidata_pages,
                 "Date", "Pages", "Wikidata Pages, by month", legend_name = "pages",
                 smoothing = ifelse(smooth_level == "global", input$smoothing_global, smooth_level))
  })
  output$wikidata_properties_plot <- renderDygraph({
    smooth_level <- input$smoothing_wikidata_properties
    make_dygraph(wikidata_properties,
                 "Date", "Properties", "Wikidata Properties, by month", legend_name = "properties",
                 smoothing = ifelse(smooth_level == "global", input$smoothing_global, smooth_level))
  })
})
