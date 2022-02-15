#!/usr/bin/env Rscript

suppressPackageStartupMessages({
    library(dplyr)
    library(arules)
    library(optparse)
    library(glue)
    library(mlhub)
    library(tools)
})

setwd(get_cmd_cwd())

parser <- OptionParser()
parser <- add_option(parser,
                     c("-o", "--output"),
                     action = "store",
                     default = "stdout",
                     help = "Output frequent itemsets file (.csv or .rds) [default: %default]",
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
argv <- parse_args(parser, positional_arguments=TRUE)

# Handle positional argument - input filename

input <- ifelse(length(argv$args),
                argv$args[1],
                "stdin")

output <- argv$options$output

fext <- ifelse(output == "stdout",
               "stdout",
               file_ext(output))

ident <- argv$options$id

threshold <- argv$options$support

if (! fext %in% c("stdout", "csv", "rds"))
  stop(glue("file extension expected as either 'csv' or 'rds' ",
            "found '{fext}'."))

dataset <- read.csv(file(input),  # file() is necessary to read from stdin
                    na.strings = c(".", "NA", "", "?"),
                    strip.white = TRUE, encoding = "UTF-8")

if (!(ident %in% colnames(dataset))) {
    msg = glue("A basket identifier '{ident}' ",
               "was not found amongst the columns: ",
               "{paste(names(dataset), collapse=', ')}.\n",
               "      Use '--id=<column>' to specify the identifier.")
    stop(msg, call. = FALSE)
}

dataset %>% 
    rename(id=!!ident) %>% 
    select(id, everything()) -> 
df

as(split(df[, 2], df[, 1]), "transactions") %>%
    apriori(parameter = list(
                support = threshold,
                minlen = 2,
                target = "frequent itemsets"),
            control = list(verbose = FALSE)
    ) %>%
    sort(by = "support") ->
itemsets

if (fext == "rds") {
  saveRDS(itemsets, output)
} else {
  itemsets %>%
    as("data.frame") %>%
    rename(pattern=items, freq=count) %>%
    select(pattern, freq, support) ->
  df
  if (fext == "csv")
    write.csv(df, output, row.names=FALSE)
  else
    write.csv(df, "", row.names=FALSE)
}
