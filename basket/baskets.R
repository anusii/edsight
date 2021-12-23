#!/usr/bin/env Rscript
import::here(apriori, inspect, sort, head, .from=arules)
import::here(arg_parser, add_argument, parse_args, .from=argparser)


parser <- arg_parser("Simple basket analysis");
parser <- add_argument(parser, "--csv", help="CSV data filename", default=NULL, type="character", short="-f");
parser <- add_argument(parser, "--support", help="The support of Apriori algorithm", default=0.1, type="double", short="-s");
argv <- parse_args(parser);

if (is.na(argv$csv)) {
    print(parser);
    stop("No CSV data file provided\n", call.=FALSE);
}

dataset <- read.csv(argv$csv,
                    na.strings=c(".", "NA", "", "?"),
		            strip.white=TRUE, encoding="UTF-8");
transactions <- as(split(dataset$course, dataset$uid), "transactions");

rules <- apriori(transactions, parameter = list(support=argv$support, confidence=0.1, minlen=2));
inspect(head(rules, n=5, by="support", decreasing=TRUE));
# inspect(sort(rules, by="support"));  # print all rules
