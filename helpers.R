library(RPostgreSQL)

get_db <- function() {
    #Modify the following line to point to a different data set, if you want. Or just replace the db file with an appropriate one.
    db_data <- readRDS("db_v6phm_1_3.data")
    drv <- dbDriver("PostgreSQL")
    db <- dbConnect(drv, host=db_data$host,
                        port=db_data$port,
                        dbname=db_data$dbname,
                        user=db_data$user,
                        password=db_data$password)
    return(db)
}

get_tissues_from_db <- function(db) {
    tissue_tag <- dbGetQuery(db, "SELECT * FROM tissue ORDER BY tag;")
    return(tissue_tag)
}

get_tissue_tag <- function(db) {
    tissue <- get_get_tissues_from_db(db)
    sgt <- c("All", tissue$tag)
    return(sgt)
}

get_pheno_tag <- function(db) {
    pheno_tag <- dbGetQuery(db, "SELECT DISTINCT tag FROM pheno WHERE pheno.hidden = false ORDER BY tag;")
    sgp <- c("All", pheno_tag$tag)
    return(sgp)
}

get_phenos_from_db <- function(db) {
    pheno <- dbGetQuery(db, "SELECT * FROM pheno WHERE pheno.hidden = false ORDER BY tag;")
    return(pheno)
}

get_pheno_tag <- function(db) {
    pheno <- get_phenos_from_db(db)
    sgp <- c("All", pheno$tag)
    return(sgp)
}

get_pheno_info_from_db <- function(db) {
    query <- paste(
        'SELECT pheno.id, ',
        'pheno.tag,',
        'pheno_info.id,',
        'pheno_info.file,',
        'pheno_info.source_file,',
        'pheno_info.portal,',
        'pheno_info.consortium,',
        'pheno_info.link,',
        'pheno_info.pubmed_paper_link,',
        'pheno_info.efo,',
        'pheno_info.hpo,',
        'pheno_info.name,',
        'pheno_info.sample_size,',
        'pheno_info.population,',
        'pheno_info.file_date',
        ' FROM pheno INNER JOIN pheno_info ON pheno.id = pheno_info.pheno_id ',
        ' WHERE pheno.hidden = false',
        ' ORDER BY pheno.tag;'
    )

    data <- dbGetQuery(db, query)
    data
}

pheno_info_with_tag <- function(phenos, tag) {
    info <- phenos[phenos$tag == tag,]
    if (length(info) > 0 && nrow(info) == 1) {
        info <- list(tag = info$tag,
            file = info$file,
            source_file = info$file,
            portal = info$portal,
            consortium = info$consortium,
            link = info$link,
            pubmed_paper_link = info$pubmed_paper_link,
            efo = info$efo,
            hpo = info$hpo,
            name = info$name,
            sample_size = info$sample_size,
            population = info$population,
            file_date = info$file_date)
    } else {
        info <- NULL
    }
    info
}

update_ui_cook <- function() {
    db <- get_db()
    sgt <- get_tissue_tag(db)
    write(sgt, file="data/sgt")
    sgp <- get_pheno_tag(db)
    write(sgp, file="data/sgp")
    dbDisconnect(db)
}

naive_string_sanitation <- function( text ) {
  sanitized <- strsplit(gsub("[^(-[:alnum:]) ]", "", text), " +")[[1]]
  sanitized <- paste(sanitized, collapse = '')
  sanitized
}

build_id_matches <- function(df, pattern) {
    keys <- strsplit(pattern, ' ')[[1]]
    id_matches <- integer()
    l <- tolower(df$tag)
    for (k in keys) {
      if (nchar(k)==0) {
        next;
      }
      matches <- df[grep(tolower(k), l), ]
      id_matches <- c( id_matches, matches$id)
    }
    as.character(unique(id_matches))
}

build_id_matches_in_clause <- function(pattern, id_matches, id_clause) {
    clause <- ""
    if (length(id_matches) > 0) {
      clause <- paste0(
                  " AND ",
                  id_clause,
                  " in (",
                  paste0(id_matches, collapse = ', '),
                  ") ")
    }
    clause
}

where_pheno_pattern_query <- function(pattern) {
    id_matches <- build_id_matches(p, pattern)
    build_id_matches_in_clause(pattern, id_matches, "p.id")
}

where_tissue_pattern_query <- function(pattern) {
    id_matches <- build_id_matches(t, pattern)
    build_id_matches_in_clause(pattern, id_matches, "t.id")
}

get_results_data_from_db <- function(input) {
    # Construct the fetching query
    where <- " WHERE m.pval IS NOT null and p.hidden != true"

    if (nchar(input$gene_name) > 0){
      s <- naive_string_sanitation(input$gene_name)
      s <- get_gene_name_field_conversion(s)
      where <- paste0(where, " AND g.gene_name LIKE '", s, "%'")
    }

    if (nchar(input$pheno_pattern) >0) {
      where <- paste0(where, where_pheno_pattern_query(input$pheno_pattern))
    }

    if (nchar(input$tissue_pattern) >0) {
      where <- paste0(where, where_tissue_pattern_query(input$tissue_pattern))
    }

    if (input$pheno != "All") {
      where <- paste0(where, " AND m.pheno_id = ", p[p$tag==input$pheno,]$id, "")
    }

    if (input$tissue != "All") {
      where <- paste0(where, " AND m.tissue_id = ", t[t$tag==input$tissue,]$id, "")
    }

    if (is.numeric(input$threshold) && input$threshold > 0) {
      t = input$threshold
      where <- paste0(where, " AND pval < ", t)
    }

#    if (is.numeric(input$r2_threshold) && input$r2_threshold > 0) {
#        r2_threshold = input$r2_threshold
#        where <- paste0(where, " AND pred_perf_R2 > ", r2_threshold)
#    }

    query <- paste0(
    "SELECT ",
    "g.gene_name,",
    " m.zscore,",
    " m.effect_size,",
    " m.pval,",
    " p.tag as phenotype,",
    " t.tag as tissue,",
    " m.pred_perf_R2,",
    " m.pred_perf_pval,",
    " m.pred_perf_qval,",
    " m.n as n_snps_used,",
    " m.model_n as n_snps_in_model",
    " FROM gene AS g ",
    " INNER JOIN metaxcan_result AS m ON g.id = m.gene_id ",
    " INNER JOIN tissue AS t ON t.id = m.tissue_id ",
    " INNER JOIN pheno AS p ON p.id = m.pheno_id ",
    where);

    if (input$ordered){
        query <- paste0(query, " ORDER BY pval");
    }
    l = 100
    if (input$limit > 1) {
      l = input$limit
    }

    query <- paste0(query, " LIMIT ", l);
    query <- paste0(query, ";")

    db <- get_db()
    data <- dbGetQuery(db, query)
    dbDisconnect(db)

    data
}

post_process_results <- function(data) {
    if(length(data$effect_size) > 0) {
        data$effect_size <- round(data$effect_size,2)
        data$zscore <- round(data$zscore,2)
        data$pval <- signif(data$pval,2)
        data$pred_perf_r2 <- round(data$pred_perf_r2,2)
        data$pred_perf_pval <- signif(data$pred_perf_pval,2)
        data$pred_perf_qval <- signif(data$pred_perf_qval,2)
    }
    data
}

get_gene_key <- function(path) {
  entries <- read.csv(path, header=FALSE, stringsAsFactors=FALSE)$V1
  l <- as.list(entries)
  names(l) <- tolower(entries)
  return(l)
}

get_pass_through <- function(path) {
  entries <- read.csv(path, header=FALSE, stringsAsFactors=FALSE)$V1
  entries <- tolower(entries)
  return(entries)
}

gene_key <- get_gene_key("gene_keys.txt")

get_gene_name_field_conversion <- function(k) {
    c_k <- paste0("^",tolower(k))
    if (nchar(k)>2 && sum(grepl(c_k, names(gene_key))) > 0) {
    # Problem is, there exist "C6ORF165" and genes like "C6orf1", which would have a similar lower cased' root
#        ind <- grep(c_k, names(gene_key))[1]
#        gk <- gene_key[[ names(gene_key)[ind] ]]
#        gk <- substr(gk,1, length(k))
        return(k)
    }
    return(toupper(k))
}