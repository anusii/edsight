#!/usr/bin/env Rscript

suppressPackageStartupMessages({
    library(dplyr)
    library(arules)
    library(optparse)
    library(glue)
    library(mlhub)
})

setwd(get_cmd_cwd())

parser <- OptionParser()
parser <- add_option(parser,
                     c("-i", "--input"),
                     action = "store",
                     default = "stdin",
                     help = "CSV data file [default: standard input]",
                     type = "character")
parser <- add_option(parser,
                     c("-b", "--binaryfile"),
                     action = "store",
                     default = NULL,
                     help = "Name of binary file to save the frequent itemsets [default: %default]",
                     type = "character")
parser <- add_option(parser,
                     c("-o", "--outputfile"),
                     action = "store",
                     default = "",
                     help = "CSV file to write the frequent itemsets, ignored if --binaryfile is set [default: standard output]",
                     type = "character")
parser <- add_option(parser,
                     "--id",
                     action = "store",
                     default = "id",
                     help = "The basket identification variable/column [default: %default]",
                     type = "character")
parser <- add_option(parser,
                     c("-s", "--support"),
                     action = "store",
                     default = 0.1,
                     help = "The support for the Apriori algorithm [default: %default]",
                     type = "double")
parser <- add_option(parser,
                     c("-c", "--confidence"),
                     action = "store",
                     default = 0.1,
                     help = "The confidence for the Apriori algorithm [default: %default]",
                     type = "double")
argv <- parse_args(parser, positional_arguments=TRUE)

# Handle positional argument - input filename

if (length(argv$args)) {
  argv$options$input = argv$args[1]
}

if (!is.null(argv$options$binaryfile) && argv$options$outputfile != "") {
    print(glue("WARN: --outputfile={argv$options$outputfile} is ignored"))
}

dataset <- read.csv(file(argv$options$input),  # file() is necessary to read from stdin
                    na.strings = c(".", "NA", "", "?"),
                    strip.white = TRUE, encoding = "UTF-8")

if (!(argv$options$id %in% colnames(dataset))) {
    msg = glue("A basket identifier '{argv$options$id}' ",
               "was not found amongst the columns: ",
               "{paste(names(dataset), collapse=', ')}.\n",
               "      Use '--id=<column>' to specify the identifier.")
    stop(msg, call. = FALSE)
}

dataset %>% 
    rename(id=argv$options$id) %>% 
    select(id, everything()) -> 
df

as(split(df[, 2], df[, 1]), "transactions") %>%
    apriori(parameter = list(
                support = argv$options$support,
                confidence = argv$options$confidence,
                minlen = 2,
                target = "frequent itemsets"),
            control = list(verbose = FALSE)
    ) %>%
    sort(by = "support") ->
itemsets

if (!is.null(argv$options$binaryfile)) {
    ifelse(
        endsWith(argv$options$binaryfile, '.rds'),
        argv$options$binaryfile,
        paste0(argv$options$binaryfile, '.rds')
    ) ->
    fout
    saveRDS(itemsets, fout)
} else {
    fout <- argv$options$outputfile
    itemsets %>%
        as("data.frame") %>%
        rename(
            pattern = items,
            freq = count
        ) %>%
        select(pattern, freq, support) %>%
        write.csv(fout, row.names = FALSE)
}

if (!is.null(argv$options$binaryfile) || argv$options$outputfile != "") {
    print(glue("{length(itemsets)} frequent itemsets saved to {fout}"))
}
