source("helpers.R")
source("uiHelpers.R")
source("uiHeader.R")

#reset Shiny Server when data gets updated
# sgt <- c("All", t$tag)
# sgp <- c("All", p$tag)

build_ui <- function(){
  f <- fluidPage(
    shinyjs::useShinyjs(),
    tags$head(includeScript("google-analytics.js")),
    appTitle(), # uiHeader.R
    releaseDate(),
    alertMessage(),
    dataInfo(),
    modelsInfo(),
    htmlTemplate("modal.html",
      title = "Phenotype Information",
      content = uiOutput("phenoInformation")
    ),
    h3("Results:"),
    fluidRow(column(2, selectInput( "display", "What to show:",
                 c(Results = 'results',
                 Phenotypes = 'pheno')))),
    conditionalPanel(
      condition = "input.display == 'results'",
      fluidRow(
        column(2, selectizeInput(inputId = "gene_name",
                                 label = "Filter by gene(s):",
                                 choices = NULL,
                                 selected = NULL,
                                 multiple = TRUE,
                                 # list of options for selectize.js available at: github.com/selectize/selectize.js/blob/master/docs/usage.md
                                 options = list(closeAfterSelect = FALSE, openOnFocus = TRUE, loadThrottle = NULL))),
        column(1),
        column(3, selectizeInput(inputId = "tissue",
                                label = "Filter by tissue(s):",
                                choices = NULL,
                                selected = NULL,
                                multiple = TRUE,
                                width = 500,
                                # list of options for selectize.js available at: github.com/selectize/selectize.js/blob/master/docs/usage.md
                                options = list(closeAfterSelect = FALSE, openOnFocus = TRUE, loadThrottle = NULL))),
        column(1),
        column(4, selectizeInput(inputId = "pheno",
                                 label = "Filter by phenotype(s):",
                                 choices = c('', p$tag),
                                 selected = '',
                                 multiple = TRUE,
                                 width = 650,
                                 # list of options for selectize.js available at: github.com/selectize/selectize.js/blob/master/docs/usage.md
                                 options = list(closeAfterSelect = FALSE, openOnFocus = TRUE, loadThrottle = NULL)))
      ),
      fluidRow(
        column(2, checkboxInput("ordered", label = "Order by p-value", value = TRUE)),
        column(1),
        column(1, numericInput("r2_threshold", "R2 threshold:", 0.01, min = 0, max = 1, step = 0.001)),
        column(1, numericInput("threshold", "P-value thres.:", 0.05, width = 200), min = 0, max = 1, step = 0.001),
        column(1, numericInput("limit", "Record limit:", 100), min = 1),
        column(1),
        column(1, checkboxInput("hide", label = "Hide suspicious results", value = TRUE)),
        column(1, checkboxInput("smr_f", label = "Only with SMR")),
        column(1, checkboxInput("twas_f", label = "Only with TWAS"))
      ),
      uiOutput("loading"),
      fluidRow(
        DT::dataTableOutput(outputId="results")
      ) #,
    ),
    conditionalPanel(
      condition = "input.display == 'pheno'",
      fluidRow(
        DT::dataTableOutput(outputId="pheno")
      )
    ),
    p("'Tissue' stands for different transcriptome models used when generating the association."),
    disclaimer(),
    cites()
  )
  f
}

shinyUI(
    build_ui()
)
