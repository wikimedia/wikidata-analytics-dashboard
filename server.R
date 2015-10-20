#Load Data
get_data <- function(updateProgress = NULL) {
  if (is.function(updateProgress)) {
    updateProgress(detail = "getting local ...")
    get_local_datasets()
    get_local_sparql_results()
    updateProgress(detail = "getting remote ...")
    get_remote_datasets()
    updateProgress(detail = "getting rdf ...")
    load_rdf_model()
    get_rdf_objects()
    updateProgress(detail = "finished")
  }
}
#Start Server
function(input, output, session) {

    progress <- shiny::Progress$new()
    progress$set(message = "Fetching data", value = 0)
    on.exit(progress$close())
    updateProgress <- function(value = NULL, detail = NULL) {
      if (is.null(value)) {
        value <- progress$getValue()
        value <- value + (progress$getMax() - value) / 5
      }
      progress$set(value = value, detail = detail)
    }
    get_data(updateProgress)

    observe({
      context <- parseQueryString(session$clientData$url_search)
      if (!is.null(context$t)) {
        observeEvent(context$t, {
          updateTabItems(session, "tabs", context$t)
        })
      }
    })

    observeEvent(input$switchtab, {
        updateTabItems(session, "tabs", input$switchtab)
    })

    # Home
    source('./src/output/server-home.R', local=TRUE)
    # Recent
    source('./src/output/server-recent.R', local=TRUE)
    # Developer
    source('./src/output/server-developer.R', local=TRUE)
    # RDF
    source('./src/output/server-RDFQ.R', local=TRUE)
    # Engagement
    source('./src/output/server-engagement.R', local=TRUE)
    # Content
    source('./src/output/server-content.R', local=TRUE)
    # KPI
    source('./src/output/server-KPI.R', local=TRUE)
}
