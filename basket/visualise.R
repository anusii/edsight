#!/usr/bin/env Rscript

suppressPackageStartupMessages({
    library(dplyr)
    library(arules)
    library(optparse)
    library(glue)
    library(mlhub)
    library(arulesViz)
    library(mlhub)
})

setwd(get_cmd_cwd())

parser <- OptionParser()
argv <- parse_args(parser, positional_arguments=TRUE)

if (length(argv$args) != 1)
  stop("Exactly on argument is required: rds filename containin model")

input  <- argv$args[1]

readRDS(input) %>%
  sort(by = "support") %>%
  plot(method = "graph",
       shading = "support",
       measure = "confidence",
       engine="ggplot2",
       limit = 10)

# This is a hack to show the visualisation in non-interactive mode where
# the plot is automatically saved to file `Rplots.pdf`.
# However, a more "natural" approach would be preferred.

mlpreview("Rplots.pdf")

