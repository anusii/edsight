all: test01

mcomp.csv:
	wget -O mcomp.csv https://raw.githubusercontent.com/anusii/edsight/main/basket/mcomp.csv

test01: mcomp.csv
	Rscript ../itemsets.R mcomp.csv > $@.stdout
	diff -c0 $@.expect $@.stdout

