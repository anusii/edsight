## Frequent itemsets and association rules data

Frequent itemsets data found by `itemsets.R`:

- `GCDE_itemsets.rds`: 12 frequent itemsets for GCDE
- `MADAN_itemsets.rds`: 78 frequent itemsets for MADAN
- `MComp_itemsets.rds`: 628 frequent itemsets for MComp

Association rules data found by `train.R`:

- `GCDE_arules.rds`: 30 association rules for GCDE
- `MADAN_arules.rds`: 227 association rules for MADAN
- `MComp_arules.rds`: 1928 association rules for MComp

To load the data, use the `readRDS` function in R, e.g.,

```console
GCDE_itemsets <- readRDS("GCDE_itemsets.rds")
inspect(GCDE_itemsets)
```
