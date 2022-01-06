#!/usr/bin/env Rscript

suppressPackageStartupMessages({
    library(dplyr)
    library(arules)
    library(argparser)
    library(glue)
})


parser <- arg_parser("Simple basket analysis")
parser <- add_argument(parser, "datafile",
                       help = "CSV data filename",
                       default = NULL,
                       type = "character")
parser <- add_argument(parser, "--id",
                       help = "The name of identification variable",
                       default = "id",
                       type = "character")
parser <- add_argument(parser, "--support",
                       help = "The support for the Apriori algorithm",
                       default = 0.1,
                       type = "double",
                       short = "-s")
parser <- add_argument(parser, "--confidence",
                       help = "The confidence for the Apriori algorithm",
                       default = 0.1,
                       type = "double",
                       short = "-c")
parser <- add_argument(parser, "--output",
                       help = "CSV file to write the association rules",
                       default = "",
                       type = "character",
                       short = "-o")
argv <- parse_args(parser)

dataset <- read.csv(argv$datafile,
                    na.strings = c(".", "NA", "", "?"),
                    strip.white = TRUE, encoding = "UTF-8")

if (!(argv$id %in% colnames(dataset))) {
    msg = glue("A basket identifier '{argv$id}' ",
               "was not found amongst the columns: ",
               "{paste(names(dataset), collapse=', ')}.\n",
               "      Use '--id <column>' to specify the identifier.")
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
    as("data.frame")
