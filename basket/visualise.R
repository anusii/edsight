#!/usr/bin/env Rscript

suppressPackageStartupMessages({
    library(dplyr)
    library(arules)
    library(optparse)
    library(glue)
    library(mlhub)
    library(arulesViz)
    library(mlhub)
    library(ggplot2)
})

setwd(get_cmd_cwd())

parser <- OptionParser()
argv <- parse_args(parser, positional_arguments=TRUE)

if (length(argv$args) != 1)
  stop("Exactly on argument is required: rds filename containin model")

input  <- argv$args[1]

readRDS(input) %>%
  sort(by = "support") ->
subrules

plot(subrules,
     method="graph",
     engine="graphviz",
     shading="support",
     measure="confidence",
     limit=10)

# This is a hack to show the visualisation in non-interactive mode where
# the plot is automatically saved to file `Rplots.pdf`.
# However, a more "natural" approach would be preferred.

mlpreview("Rplots.pdf", begin="")

# ALTERNATIVES

## plot(subrules, method = "graph",
##        shading = "support",
##        measure = "confidence",
##        engine="ggplot2",
##        # engine="igraph",
##        # engine="graphviz",
##        # control=list(main="XXX", layoutParams="help", alpha=0.5, measureLabels=TRUE, itemnodeCol="green", labelCol="blue", plot_options=list(nodes=list(fill="lightgrey", textCol="red"))),
##        # engine="visNetwork",
##        # engine="interactive",
##        limit = 10)

##   plot(subrules, method = "graph", 
##        control = list(
##          edges = ggraph::geom_edge_link(
##            end_cap = ggraph::circle(4, "mm"),
##            start_cap = ggraph::circle(4, "mm"),
##            color = "black",
##            arrow = arrow(length = unit(2, "mm"), angle = 20, type = "closed"),
##            alpha = .2
##          ),
##          nodes = ggraph::geom_node_point(aes_string(size = "confidence", color = "support")),
##          nodetext = ggraph::geom_node_label(aes_string(label = "label"), alpha = .8, repel = TRUE)
##        ),
##        limit = 10
##        ) + 
##   scale_color_gradient(low = "yellow", high = "red") + 
##   scale_size(range = c(0, 10)) 


## plot(subrules, method = "graph", asEdges = TRUE, limit = 10)

## plot(subrules, method = "graph", asEdges = TRUE, circular = FALSE, limit = 10)

## plot(subrules, method = "graph", engine = "igraph", limit = 10)

## plot(subrules, method = "graph", engine = "igraph",
##   nodeCol = grey.colors(10), edgeCol = grey(.7), alpha = 1,
##   limit = 10)

## plot(subrules, method = "graph", engine = "igraph", shading = "support", measure = "confidence",
##   plot_options = list(
##     edge.lty = 1, 
##     vertex.label.cex = 0.8, 
##     margin = c(.1,.1,.1,.1), 
##     asp = .8),
##   limit = 10)

## plot(subrules, method="graph", engine = "igraph", layout = igraph::in_circle(), limit = 10, shading = "support", measure = "confidence")

## #NICEST CHOOSE THIS ONE

## plot(subrules, method = "graph", engine = "graphviz", shading = "support", measure = "confidence", limit = 10)

