source("helpers.R", local = TRUE)

# Tissues and phenotypes are largely inmutable.
# no need in requesting them all the time.
# Reset the server when new stuff gets stored in the database.

db <- get_db()
t <- get_tissues_from_db(db)
p <- get_pheno_info_from_db(db)
g <- get_genes_from_db(db)

dbDisconnect(db)
