library(magrittr)
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

render_results <- function(data) {
  render <- DT::datatable(data,
  class = 'compact display',

  options = list(
      pageLength = 20,
      lengthMenu = c(10, 20, 40, 100)
  ),
  selection = 'single')
  # multiple pipes didnt work across several line s:/

  if (nrow(data)>0) {
    render <- render %>%
      DT::formatRound('zscore',2) %>%
      DT::formatRound('effect_size',2) %>%
      DT::formatSignif('pval',2) %>%
      DT::formatSignif('mt_pval',2) %>%
      DT::formatSignif('pred_perf_r2',2) %>%
      DT::formatSignif('pred_perf_pval',2) %>%
      DT::formatSignif('pred_perf_qval',2) %>%
      DT::formatSignif('p_smr', 2) %>%
      DT::formatSignif('p_heidi', 2) %>%
      DT::formatSignif('coloc_prob4', 2) %>%
      DT::formatSignif('coloc_prob3', 2)
  }
  render
}

# Define a server for the Shiny app
shinyServer(function(input, output, session) {
 
  # Filter data based on selections
  selected_pheno <- ""
  results_index <- data.frame()
  pheno_index <- data.frame()
  selected_index <- -1
  
  updateSelectizeInput(session = session, inputId = 'gene_name', choices = c(Choose = '', g$gene_name), server = TRUE)
  updateSelectizeInput(session = session, inputId = 'tissue', choices = c(Choose = '', t$tag), server = TRUE)
  
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
    data <- post_process_results(data)
    if ( length(data) ){
        results_index <<- data[,"phenotype"]
    }
    render_results(data)
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

  output$loading <- renderUI({fluidPage(
    tags$head(tags$style(type="text/css", "
             #loadmessage {
               position: relative;
               top: 300px;
               box-shadow: 6px 6px 18px #808080;
               border: 2px;
               border-radius: 5px;
               left: 0px;
               width: 100%;
               padding: 25px 0px 25px 0px;
               text-align: center;
               font-weight: bold;
               font-size: 100%;
               color: #000000;
               background-color: #CCFF66;
               z-index: 105;
               opacity: 0.7;
             }
        ")),
    conditionalPanel(
      condition="($('html').hasClass('shiny-busy'))",
      tags$div("Loading...", id="loadmessage")
    ))
  })
  
})
