## Simple Basket Analysis

### How to run the scripts
- Login `sii-ftest`
- Install R packages `arules`, `import` and `argparser`. If using R-3.6, `arules` can be installed by command

  ```console
  install.packages("https://cran.r-project.org/src/contrib/Archive/arules/arules_1.6-8.tar.gz")
  ```

- Extract data from postgreSQL

  ```bash
  ./extract.sh 7705 > mcomp.csv
  ```
  where `7705` is the degree identifier for "Master of Computing"

- Simple basket analysis

  ```bash
  ./baskets.R --csv mcomp.csv
  ```
  
Noting that `/mnt/edsight` on `sii-ftest` is a common place for sharing files.
