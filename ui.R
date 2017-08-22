source("helpers.R")
source("uiHelpers.R")

#reset Shiny Server when data gets updated
sgt <- c("All", t$tag)
sgp <- c("All", p$tag)

# Not used at the moment, but might come back
build_ui_d <- function(){
  f <- fluidPage(
    shinyjs::useShinyjs(),
    titlePanel("Metaxcan Association results"),
    p("Data Release: November 18, 2016"),
    p("Tissues and covariances built on V6P HapMap"),
    htmlTemplate("modal.html",
      title = "Phenotype Information",
      content = uiOutput("phenoInformation")
    ),
    p("'Tissue' stands for different transcriptome models used when generating the association."),
    p("Tissues built with GTEX and DGN data, covariances with 1000 Genomes."),
    fluidRow(
      column(2, textInput("gene_name", "Gene Name:","")),
      column(1, checkboxInput("ordered", label = "Ordered", value = TRUE)),
      column(2, selectInput("pheno", "Phenotype:", sgp)),
      column(2, selectInput("tissue", "Tissue:", sgt)),
      column(1, numericInput("r2_threshold", "R2 threshold:",0.01)),
      column(1, numericInput("threshold", "Pvalue threshold:",0.05)),
      column(1, numericInput("limit", "Record limit:", 100))
    ),
    fluidRow(
      DT::dataTableOutput(outputId="results")
    )#,
    #fluidRow(
    #  DT::dataTableOutput(outputId="pheno")
    #)
  )
  f
}

build_ui <- function(){
  f <- fluidPage(
    shinyjs::useShinyjs(),
    tags$head(includeScript("google-analytics.js")),
    titlePanel("Metaxcan Association results, Multi Tissue Prototype"),
    p("Data Release: August 10, 2017."),
    p("Complemented with SMR and COLOC runs."),
    p("GTEx Prediction models and covariances built with GTEx V6P on HapMap SNPs."),
    p("DGN Prediction Model built with Depression Genes and Networks study data."),
    htmlTemplate("modal.html",
      title = "Phenotype Information",
      content = uiOutput("phenoInformation")
    ),
    h3("Results:"),
    selectInput(
      "display", "What to show:",
      c(Results = 'results',
        Phenotypes = 'pheno')),
    conditionalPanel(
      condition = "input.display == 'results'",
      fluidRow(
        column(2, textInput("gene_name", "Gene Name:","")),
        column(1, checkboxInput("ordered", label = "Ordered", value = TRUE)),
        column(2, selectInput("pheno", "Phenotype:", sgp)),
        column(2, selectInput("tissue", "Tissue:", sgt)),
        column(1, numericInput("r2_threshold", "R2 threshold:",0.01)),
        column(1, numericInput("threshold", "Pvalue threshold:",0.05)),
        column(1, numericInput("limit", "Record limit:", 100)),
        column(1, checkboxInput("smr_f", label = "Only with SMR"))
      ),
      fluidRow(
        column(2, p("(Admits lowercase gene names except for 'C*orf*' genes which need precise case)")),
        column(1),
        column(2, textInput("pheno_pattern", "Patterns:", "")),
        column(2, textInput("tissue_pattern", "Patterns:", "")),
        column(3),
        column(1, checkboxInput("twas_f", label = "Only with TWAS"))
      ),
      fluidRow(
        DT::dataTableOutput(outputId="results")
      )#,
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
