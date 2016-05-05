# Metaxcan results web report

This shiny app connects to a postgre database with metaxcan results and displays them in a data table.

## Database 

At the moment, this is expecting a Postgre database.

Expected schema is:

```SQL
CREATE TABLE gene
(
  id serial NOT NULL,
  gene character varying,
  gene_name character varying,
  CONSTRAINT gene_pkey PRIMARY KEY (id)
);
CREATE TABLE pheno
(
"id" SERIAL PRIMARY KEY,
"tag" varchar,
"hidden" bool
);

CREATE TABLE tissue
(
"id" SERIAL PRIMARY KEY,
"tag" varchar,
"type" varchar,
"tissue" varchar,
"model" varchar,
"training_set" varchar
)

CREATE TABLE IF NOT EXISTS  (
"id" SERIAL PRIMARY KEY,
"zscore" real,
"n" integer,
"model_n" integer,
"pred_perf_r2" real,
"pval" double precision,
"tissue_id" integer REFERENCES tissue(id),
"pheno_id" integer REFERENCES pheno(id),
"gene_id" integer REFERENCES gene(id)
);

CREATE TABLE IF NOT EXISTS pheno_info (
id SERIAL PRIMARY KEY,
pheno_id Integer REFERENCES pheno(id),
file varchar,
source_file varchar,
portal varchar,
consortium varchar,
link varchar,
PUBMED_paper_link varchar,
EFO varchar,
HPO varchar,
name varchar,
sample_size integer,
population varchar,
file_date date
);
```

And you probably should create indexes such as:

```SQL
CREATE INDEX g_gene_name_idx ON gene(gene_name);

CREATE INDEX p_pheno_tg_idx ON pheno(tag);

CREATE INDEX p_tissue_tg_idx ON tissue(tag);

CREATE INDEX mr_pheno_id_idx ON metaxcan_results(pheno_id);

CREATE INDEX mr_tissue_id_idx ON metaxcan_results(tissue_id);

CREATE INDEX mr_gene_id_idx ON metaxcan_results(gene_id);

CREATE INDEX mr_pval_idx ON metaxcan_results(pval);
```

## Run

Prerequisites are **shiny**, **shinyjs**, **RPostgreSQL**, **DT**. Try to install them using `devtools`,
the CRAN packages were mostly outdated at the time of this writing.
Then, you can run `shiny::runApp()` at an R console started at the project folder.

## deploy

You need to have `rsconnect`R Package installed. You need to configure your acount info by running:

```R
rsconnect::setAccountInfo(name='myaccount', token='MY_TOKEN', secret='MY_SECRET')
```

Then, from an R console started at the project, run `deployApp(appName="My App or Whatever")`.
Shiny's package logic is somewhat obscure. I specifically chose `US TX` R mirror for this to work.

