#!/usr/bin/env Rscript

# library(tidyverse, quietly = TRUE)
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(arules))
suppressPackageStartupMessages(library(argparser))


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
                       help = "The support of Apriori algorithm",
                       default = 0.1,
                       type = "double",
                       short = "-s")
argv <- parse_args(parser)

# if (is.na(argv$datafile)) {
#     print(parser)
#     stop("No CSV data file provided\n", call. = FALSE)
# }

dataset <- read.csv(argv$datafile,
                    na.strings = c(".", "NA", "", "?"),
                    strip.white = TRUE, encoding = "UTF-8")

if (!(argv$id %in% colnames(dataset))) {
    print(parser)
    stop(sprintf(fmt="The identification variable \"%s\" does not exist in the dataset\n", argv$id), call. = FALSE)
}

dataset %>% rename(id=argv$id) %>% select(id, everything()) -> df

transactions <- as(split(df[, 2], df[, 1]), "transactions")

rules <- apriori(transactions,
                 parameter = list(support = argv$support,
                                  confidence = 0.1,
                                  minlen = 2),
                 control = list(verbose = FALSE))
inspect(head(rules, n = 5, by = "support", decreasing = TRUE))

# inspect(sort(rules, by="support"));  # print all rules
