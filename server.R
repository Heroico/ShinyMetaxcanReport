source("helpers.R", local=TRUE)
source("phenoInfoModule.R", local=TRUE)

selection_event <- function(selected, index) {
    info <- NULL
    if (length(selected) && length(index)) {
      selected_row = as.numeric(tail(selected, 1))
      selected_pheno_key <- index[as.numeric(selected_row)]
      info <- pheno_info_with_tag(p, selected_pheno_key)
    }
    info
}

# Define a server for the Shiny app
shinyServer(function(input, output) {
  # Filter data based on selections
  selected_pheno <- ""
  results_index <- data.frame()
  pheno_index <- data.frame()
  selected_index <- -1

  output$pheno <- DT::renderDataTable({
    l <- p[,names(p) %in% c("tag", "name", "population", "consortium", "sample_size")]
    pheno_index <<- l[,"tag"]
    DT::datatable(l,
      options = list(
        pageLength = 20,
        lengthMenu = c(10, 20, 40, 100)
      ),
    selection = 'single'
    )
  })

  output$results <- DT::renderDataTable({
    data <- get_results_data_from_db(input)
    if ( length(data) ){
        results_index <<- data[,"phenotype"]
    }
    DT::datatable(data,
    options = list(
      pageLength = 20,
      lengthMenu = c(10, 20, 40, 100)
    ),
    selection = 'single')
  })

# Used for debugging, mostly
#  proxy <- DT::dataTableProxy('results')

#  modal_process <- eventReactive(input$results_rows_selected, {
#    selection_event(input$results_rows_selected, results_index)
#  })

  modal_process <- reactive({
    v <- NULL
    if (input$display == "results") {
      v <- selection_event(input$results_rows_selected, results_index)
    } else if(input$display == "pheno") {
      v <- selection_event(input$pheno_rows_selected, pheno_index)
    }
    v
  })

  output$phenoInformation <- renderUIPhenoInformation(modal_process)

  observeEvent(
    input$results_rows_selected,{
    shinyjs::runjs("$('#myModal').modal()")
  })

  observeEvent(
    input$pheno_rows_selected,{
    shinyjs::runjs("$('#myModal').modal()")
  })

})

