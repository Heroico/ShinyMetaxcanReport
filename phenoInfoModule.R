library(shiny)

buildPhenoUI <- function(pheno) {
  ui <- tagList(
    fluidRow(
      column(8,p(HTML(paste0("<b>",pheno$tag), "</b>")))
    ),
    fluidRow(
      column(3,p("Name:")),
      column(4,p(pheno$name))
    ),
    fluidRow(
      column(3,p("Consortium:")),
      column(4,a(pheno$consortium, href=pheno$portal))
    ),
    fluidRow(
      column(3,p("Sample Size:")),
      column(4, p(pheno$sample_size))
    ),
    fluidRow(
      column(3,p("Population:")),
      column(4, p(pheno$population))
    ),
    fluidRow(
      column(3,p("Data Source:")),
      column(4, buildPhenoSourceElement(pheno))
    ),
    fluidRow(
      column(3,p("Paper:")),
      column(4, a("PubMed", href=pheno$pubmed_paper_link))
    ),
    fluidRow(
      column(3,p("EFO")),
      column(9,buildEFO(pheno))
    ),
    fluidRow(
      column(3,p("HPO")),
      column(9,buildHPO(pheno))
    )
  )
  ui
}

buildPhenoSourceElement <- function(pheno) {
    link <- if (length(pheno$link)) pheno$link else ""
    text <- if (length(pheno$source_file)) pheno$source_file else "Download Link"
    el <- if (length(link)) a(text, href=link) else p("Not Available")
    el
}

buildEFO <- function(pheno) {
    efo <- buildOntologyEntries(pheno$efo,"http://www.ebi.ac.uk/efo/")
    return(efo)
}

buildHPO <- function(pheno) {
    hpo <- buildOntologyEntries(pheno$hpo,"http://compbio.charite.de/hpoweb/showterm?id=")
    return(hpo)
}

buildOntologyEntries <-function(ontology, base) {
    ontos <- strsplit(ontology, "/")
    if (length(ontos) == 0) {
        return(p("Not Available"))
    }
    row <- "<ul>"
    for (onto in ontos) {
        row <- paste0(row,"<li><a href='", base, onto,"'>",onto,"</a></li>")
    }
    row <- paste0(row,"</ul>")
    HTML(row)
}

renderUIPhenoInformation <- function(phenoEvent){
  rvalue <- renderUI({
      ui <- NULL
      pheno <- phenoEvent()
      if (!is.null(pheno) && length(pheno)) {
          ui <- buildPhenoUI(pheno)
      } else {
          ui <- p("No phenotype information available")
      }
  })
  return(rvalue)
}
