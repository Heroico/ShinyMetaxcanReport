library(shiny)

disclaimer <- function() {
    h <- h3("Disclaimer")
    t <- paste0('These data are provided "as is", and without any warranty, for scientific and educational use only.',
     ' If you use or download these data, you acknowledge that ',
    ' that the investigator is in compliance with all applicable state, local, and federal laws ',
    'or regulations and institutional policies regarding human subjects and genetics research; ',
    ' that secondary distribution of the data without registration by secondary parties is prohibited; ',
    ' and that the investigator will cite the appropriate publication in any communications ',
    ' or publications arising directly or indirectly from these data.',
    ' Further restrictions may be imposed by the source of the summary statistics data linked with each phenotype.')

    d <- div(h, p(t))
    d
}

cites <- function() {

    h <- h3('References:')
    p1 <-p('Gamazon ER, Wheeler HE, Shah KP, Mozaffari SV, Aquino-Michaels K, Carroll RJ, Eyler AE, Denny JC, Nicolae DL, Cox NJ, Im HK. (2015)',
            strong(' A gene-based association method for mapping traits using reference transcriptome data. Nat Genet. doi:10.1038/ng.3367.'),
            a(href='http://www.nature.com/ng/journal/v47/n9/full/ng.3367.html', "Link to Nature Genetics"),
            a(href='http://biorxiv.org/content/early/2015/06/17/020164', "Link to Preprint"))

    p2 <- p( 'Alvaro Barbeira, Kaanan P Shah, Jason M Torres, Heather E Wheeler, Eric S Torstenson, Todd Edwards, Tzintzuni Garcia, Graeme I Bell, Dan Nicolae, Nancy J Cox, Hae Kyung Im. (2016)',
             strong(' MetaXcan: Summary Statistics Based Gene-Level Association Method Infers Accurate PrediXcan Results'),
             a(href='http://dx.doi.org/10.1101/045260', "Link to Preprint"))

    p3 <- p( 'Heather E Wheeler, Kaanan P Shah, Jonathon Brenner, Tzintzuni Garcia, Keston Aquino-Michaels, GTEx Consortium, Nancy J Cox, Dan L Nicolae, Hae Kyung Im. (2016)',
             strong('Survey of the Heritability and Sparsity of Gene Expression Traits Across Human Tissues.'),
             a(href='http://dx.doi.org/10.1101/043653', 'Link to preprint') )

    div(h,
        tags$ul(tags$li(p1), tags$li(p2), tags$li(p3)))

}
