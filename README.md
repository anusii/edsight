# edsight

Student Education Insights

## Data Extract

```bash
extract mcomp > mcomp.csv
```

```console
$ extract mcomp
uid,course
u1234567,comp1234
u1234567,comp2345
u1234567,comp3456
u1234567,comp4567
u1234568,comp1234
u1234568,comp4567
...
```

## Analysis

```bash
baskets mcomp.csv > baskets.csv
```

```console
$ baskets mcopm.csv
freq,support,pattern
145,0.75,comp1234:comp4567
123,0.45,comp2345
...
```

```console
$ baskets --support=0.5 mcomp.csv
freq,support,pattern
145,0.75,comp1234:comp4567
...
```

## Pipeline

```bash
extract mcomp | baskets > baskets.csv
```
