# edsight

Student Education Insights

## Data Extract

```bash
python extract.py mcomp > mcomp.csv
```

```console
$ python extract.py mcomp
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
python baskets.py mcomp.csv > baskets.csv
```

```console
$ python baskets.py mcopm.csv
pattern,freq,support
comp1234:comp4567,145,0.75
comp2345,123,0.45
...
```

```console
$ python baskets.py --support=0.5 mcomp.csv
pattern,freq,support
comp1234:comp4567,145,0.75
...
```

## Pipeline

```bash
python extract.py mcomp | python -s 0.5 baskets.py > top_baskets_0.5.csv
```

# Test Server

```
globalprotect connect
ssh u1234567@sii-ftest.cecs.anu.edu.au 
...
globalprotect disconnect
```
