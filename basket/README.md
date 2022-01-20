## Simple Basket Analysis

### How to run the scripts
- Login `sii-ftest`
- Install R packages `arules`, `tidyverse` and `optparse`. If using R-3.6, `arules` can be installed by command

  ```console
  install.packages("https://cran.r-project.org/src/contrib/Archive/arules/arules_1.6-8.tar.gz")
  ```

- [Install `mlhub` R package](https://survivor.togaware.com/mlhub/installing-mlhub.html)

- Extract data from postgreSQL

  ```bash
  ./extract.sh 7705 > mcomp_fais.csv
  ```
  where `7705` is the degree identifier for "Master of Computing"

- Simple basket analysis

  ```bash
  ./itemsets.R --id=uid -f mcomp_fais.csv
  ```
  or
  
  ```bash
  cat mcomp_fais.csv | ./itemsets.R --id=uid
  ```
  See `./itemsets.R --help` for details of supported options. The frequent items for MComp, GCDE and MADAN can be found in `rds/`.
  
- Association rules using dummy data `mcomp.csv`

  ```bash
  ./train.R -f mcomp.csv
  ```
  or
  
  ```bash
  cat mcomp.csv | ./train.R
  ```
    See `./train.R --help` for details of supported options. The association rules for MComp, GCDE and MADAN can be found in `rds/`.

Noting that `mcomp_fais.csv` can be found in `/mnt/edsight` on `sii-ftest`.
