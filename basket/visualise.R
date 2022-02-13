#!/usr/bin/env Rscript

suppressPackageStartupMessages({
    library(dplyr)
    library(arules)
    library(optparse)
    library(glue)
    library(mlhub)
    library(arulesViz)
    library(fs)
})

setwd(get_cmd_cwd())

parser <- OptionParser()
parser <- add_option(parser,
                     c("-f", "--datafile"),
                     action = "store",
                     default = "stdin",
                     help = "CSV data file [default: standard input]",
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
argv <- parse_args(parser)

dataset <- read.csv(file(argv$datafile),  # file() is necessary to read from stdin
                    na.strings = c(".", "NA", "", "?"),
                    strip.white = TRUE, encoding = "UTF-8")

if (!(argv$id %in% colnames(dataset))) {
    msg = glue("A basket identifier '{argv$id}' ",
               "was not found amongst the columns: ",
               "{paste(names(dataset), collapse=', ')}.\n",
               "      Use '--id=<column>' to specify the identifier.")
    stop(msg, call. = FALSE)
}

dataset %>% 
    rename(id=argv$id) %>% 
    select(id, everything()) -> 
df

as(split(df[, 2], df[, 1]), "transactions") %>%
    apriori(parameter = list(
                support = argv$support,
                confidence = argv$confidence,
                minlen = 2,
                target = "rules"),
            control = list(verbose = FALSE)
    ) %>%
    sort(by = "support") %>%
    plot(method = "graph",
         shading = "support",
         measure = "confidence", 
         limit = 10)

# This is a hack to show the visualisation in non-interactive mode where
# the plot is automatically saved to file `Rplots.pdf`.
# However, a more "natural" approach would be preferred.
file_show(path(getwd(), "Rplots.pdf"))
