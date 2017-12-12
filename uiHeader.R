library(shiny)

appTitle_ <- "MetaXcan Association results (257 phenotypes)"
releaseDate_ <- "Data Release: September 26, 2017."

alertMessage_ <- ""  # Write an alert message here

dataInfo_ <- "These results are based on GWAS summary statistics that are publicly available, as well as data from the GERA cohort."
modelsInfo_ <- "GTEx Prediction models and covariances were built with GTEx V6P on HapMap SNPs.\nDGN Prediction model was built with the Depression, Genes and Networks study data."

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
  p(modelsInfo_)
}
