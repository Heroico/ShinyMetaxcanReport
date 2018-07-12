library(shiny)

appTitle_ <- "MetaXcan Association results (114 phenotypes)"
releaseDate_ <- "Data Release: July 5, 2018."

alertMessage_ <- ""  # Write an alert message here

dataInfo_ <- "These results are based on GWAS summary statistics that are publicly available, as well as data from the UKB GWAs study by Neale Lab."

appTitle <- function(){
  titlePanel(appTitle_) 
}

releaseDate <- function(){
  p(releaseDate_)
}

alertMessage <- function(){
  if(alertMessage_ != "") 
    return(p(strong(alertMessage_, style="color:red")))
  else
    return()
}

dataInfo <- function(){
  p(dataInfo_)
}

modelsInfo <- function(){
  div(
    p("GTEx Prediction models and covariances were built with GTEx V8 on HapMap SNPs."),
    p("Models from Elastic Net; primary, secondary and tertiary eQTL; eQTLs filtered by DAP-G PIP")
  )
}
