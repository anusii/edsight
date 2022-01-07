#!/usr/bin/env Rscript

suppressPackageStartupMessages({
    library(dplyr)
    library(arules)
    library(argparser)
    library(glue)
    library(mlhub)
})

setwd(get_cmd_cwd())

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
                target = "frequent itemsets"),
            control = list(verbose = FALSE)
    ) %>%
    sort(by = "support") %>%
    as("data.frame") %>%
    rename(
        pattern = items,
        freq = count
    ) %>%
    select(pattern, freq, support) %>%
    write.csv(row.names = FALSE)
