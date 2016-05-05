source("helpers.R", local=TRUE)
source("phenoInfoModule.R", local=TRUE)


# Define a server for the Shiny app
shinyServer(function(input, output) {
  # Filter data based on selections
  selected_pheno <- ""
  rows_index <- data.frame()
  selected_index <- -1

  output$table <- DT::renderDataTable({
    data <- get_results_data_from_db(input)
    if ( length(data) ){
        rows_index <<- data[,"phenotype"]
    }
    DT::datatable(data,
    options = list(
      pageLength = 20,
      lengthMenu = c(10, 20, 40, 100)
    ),
    selection = 'single')
  })

  proxy <- DT::dataTableProxy('table')

  modal_process <- eventReactive(input$table_rows_selected, {
    s = input$table_rows_selected
    info <- NULL
    if (length(s) && length(rows_index)) {
      selected_row = as.numeric(tail(s, 1))
      selected_pheno_key <- rows_index[as.numeric(selected_row)]
      info <- pheno_info_with_tag(p, selected_pheno_key)
    }
    info
  })

  output$phenoInformation <- renderUIPhenoInformation(modal_process)

#  output$phenoInformation <- renderUI({
#    modal_process()
#  })

  observeEvent(
    input$table_rows_selected,{
    shinyjs::runjs("$('#myModal').modal()")
  })

})

