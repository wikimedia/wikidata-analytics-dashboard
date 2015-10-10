## Version 0.2.0
source("config.R")
source("model.R")
source("utils.R")

#Load Data
get_local_datasets()
get_remote_datasets()
load_rdf_model()
get_rdf_objects()

#Start Server
function(input, output, session) {

    observeEvent(input$switchtab, {
        updateTabItems(session, "tabs", input$switchtab)
    })

    # Home
    source('./output/server-home.R', local=TRUE)
    # Recent
    source('./output/server-recent.R', local=TRUE)
    # Developer
    source('./output/server-developer.R', local=TRUE)
    # RDF
    source('./output/server-RDFQ.R', local=TRUE)
    # Engagement
    source('./output/server-engagement.R', local=TRUE)
    # Content
    source('./output/server-content.R', local=TRUE)
    # KPI
    source('./output/server-KPI.R', local=TRUE)
}
