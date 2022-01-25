## Frequent itemsets and association rules data

Frequent itemsets data found by `itemsets.R`:

- `GCADAN_itemsets.rds`: 2 frequent itemsets for GCADAN
- `GCDE_itemsets.rds`: 12 frequent itemsets for GCDE
- `MADAN_itemsets.rds`: 78 frequent itemsets for MADAN
- `MComp_itemsets.rds`: 628 frequent itemsets for MComp

Association rules data found by `train.R`:

- `GCADAN_arules.rds`: 4 association rules for GCADAN
- `GCDE_arules.rds`: 30 association rules for GCDE
- `MADAN_arules.rds`: 227 association rules for MADAN
- `MComp_arules.rds`: 1928 association rules for MComp

To load the data in R, use the `readRDS` function, e.g.,

```console
GCDE_itemsets <- readRDS("GCDE_itemsets.rds")
inspect(GCDE_itemsets)  # display the itemsets
```

NOTE:

- Please ignore the *transIdenticalToItemsets* column in the itemsets, see [this arules issue](https://github.com/mhahsler/arules/issues/67)
- The [jsonlite](https://github.com/jeroen/jsonlite) R package might be helpful if JSON format is preferred, e.g., using the [serializeJSON](https://www.rdocumentation.org/packages/jsonlite/versions/1.7.3/topics/serializeJSON) function
