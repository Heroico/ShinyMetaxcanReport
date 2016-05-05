source("helpers.R")

#reset Shiny Server when data gets updated
sgt <- c("All", t$tag)
sgp <- c("All", p$tag)

build_ui <- function(){
  f <- fluidPage(
    shinyjs::useShinyjs(),
    titlePanel("Metaxcan Association results"),
    htmlTemplate("modal.html",
      title = "Phenotype Information",
      content = uiOutput("phenoInformation")
    ),
    p("'Tissue' stands for different transcriptome models used when generating the association."),
    p("Tissues built with GTEX data, covariances with 1000 Genomes."),
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

shinyUI(
    build_ui()
)
